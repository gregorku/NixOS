{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.serverUnlock;

  # ------------------------------------------------------------
  # Konfigurace jednoho spravovaného serveru
  # ------------------------------------------------------------

  serverType = lib.types.submodule {
    options = {
      host = lib.mkOption {
        type = lib.types.str;
        description = "VPN IP adresa nebo hostname serveru.";
      };

      unlockPort = lib.mkOption {
        type = lib.types.port;
        description = "SSH port initrd.";
      };

      normalPort = lib.mkOption {
        type = lib.types.port;
        description = "SSH port běžícího NixOS.";
      };

      hostPublicKey = lib.mkOption {
        type = lib.types.str;
        description = "Veřejný SSH host key initrd.";
      };

      keyFile = lib.mkOption {
        type = lib.types.str;
        default = "/root/.ssh/unlock_servers";
        description = "Soukromý SSH klíč VPS.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.str;
        description = "Cesta k souboru s LUKS heslem.";
      };
    };
  };

  # ------------------------------------------------------------
  # SSH known_hosts
  # ------------------------------------------------------------

  serverKnownHosts =
    lib.mapAttrs' (
      name: server:
        lib.nameValuePair "${name}-initrd" {
          hostNames = [
            "[${server.host}]:${toString server.unlockPort}"
          ];

          publicKey = server.hostPublicKey;
        }
    )
    cfg.servers;

  # ------------------------------------------------------------
  # Samostatný pracovní skript pro každý server
  # ------------------------------------------------------------

  mkServerWorker = name: server:
    pkgs.writeShellApplication {
      name = "server-unlock-${name}";

      runtimeInputs = with pkgs; [
        coreutils
        netcat-openbsd
        openssh
      ];

      text = ''
        set -u

        SERVER_NAME=${lib.escapeShellArg name}
        HOST=${lib.escapeShellArg server.host}
        UNLOCK_PORT=${toString server.unlockPort}
        NORMAL_PORT=${toString server.normalPort}
        SSH_KEY=${lib.escapeShellArg server.keyFile}
        PASSWORD_FILE=${lib.escapeShellArg server.passwordFile}

        CHECK_INTERVAL=${toString cfg.checkInterval}
        BOOT_TIMEOUT=${toString cfg.bootTimeout}
        BOOT_POLL_INTERVAL=${toString cfg.bootPollInterval}
        UNLOCK_TIMEOUT=${toString cfg.unlockTimeout}
        LOG_LEVEL=${lib.escapeShellArg cfg.logLevel}

        log() {
          local level="$1"
          shift

          printf '%s [%s] [%s] %s\n' \
            "$(date '+%Y-%m-%d %H:%M:%S')" \
            "$level" \
            "$SERVER_NAME" \
            "$*"
        }

        port_open() {
          local port="$1"

          nc -z -w 3 "$HOST" "$port" >/dev/null 2>&1
        }

        wait_for_normal_ssh() {
          local waited=0

          log INFO "Čekám na běžné SSH na portu $NORMAL_PORT"

          while (( waited < BOOT_TIMEOUT )); do
            if port_open "$NORMAL_PORT"; then
              log INFO "Běžné SSH je dostupné. Server naběhl."
              return 0
            fi

            sleep "$BOOT_POLL_INTERVAL"
            waited=$((waited + BOOT_POLL_INTERVAL))
          done

          log ERROR "Běžné SSH se neobjevilo během ${BOOT_TIMEOUT} sekund."
          return 1
        }

        unlock_server() {
          local ssh_status=0

          if [[ ! -r "$SSH_KEY" ]]; then
            log ERROR "Nelze číst SSH klíč: $SSH_KEY"
            return 1
          fi

          if [[ ! -r "$PASSWORD_FILE" ]]; then
            log ERROR "Nelze číst soubor s heslem: $PASSWORD_FILE"
            return 1
          fi

          log INFO "Initrd SSH je dostupné na portu $UNLOCK_PORT."
          log INFO "Odesílám LUKS heslo."

          #
          # SSH musí mít přidělený terminál (-tt),
          # protože systemd-tty-ask-password-agent
          # pracuje s terminálem.
          #
          # Host key se ověřuje proti systémovému
          # /etc/ssh/ssh_known_hosts.
          #
          # SSH proces má časový limit UNLOCK_TIMEOUT.
          #

          if timeout \
            --foreground \
            --signal=TERM \
            --kill-after=10s \
            "''${UNLOCK_TIMEOUT}s" \
            ssh \
              -tt \
              -i "$SSH_KEY" \
              -p "$UNLOCK_PORT" \
              -o BatchMode=yes \
              -o IdentitiesOnly=yes \
              -o StrictHostKeyChecking=yes \
              -o UserKnownHostsFile=/dev/null \
              -o GlobalKnownHostsFile=/etc/ssh/ssh_known_hosts \
              -o UpdateHostKeys=no \
              -o ConnectTimeout=10 \
              -o ConnectionAttempts=1 \
              root@"$HOST" \
              systemd-tty-ask-password-agent \
              < "$PASSWORD_FILE"
          then
            ssh_status=0
          else
            ssh_status=$?
          fi

          if (( ssh_status == 0 )); then
            log INFO "SSH příkaz skončil úspěšně."
          else
            log WARN "SSH skončilo s návratovým kódem $ssh_status."
          fi

          #
          # Návratový kód SSH sám o sobě nerozhoduje,
          # zda bylo LUKS odemčeno.
          #
          # Při přechodu z initrd do běžného systému
          # se může SSH spojení přerušit.
          #
          # Úspěch proto potvrzujeme běžným SSH portem.
          #

          wait_for_normal_ssh
        }

        check_server() {
          #
          # 1. Běžný systém už odpovídá.
          #

          if port_open "$NORMAL_PORT"; then
            if [[ "$LOG_LEVEL" == "debug" ]]; then
              log DEBUG "Server běží."
            fi

            return 0
          fi

          #
          # 2. Běžné SSH neodpovídá.
          #    Zkontrolujeme initrd SSH.
          #

          if port_open "$UNLOCK_PORT"; then
            unlock_server
            return $?
          fi

          #
          # 3. Neodpovídá ani jeden port.
          #

          if [[ "$LOG_LEVEL" == "debug" ]]; then
            log DEBUG "Běžné SSH ani initrd SSH nejsou dostupné."
          fi

          return 0
        }

        log INFO "Samostatná služba odemykání spuštěna."
        log INFO "Kontrola každých ''${CHECK_INTERVAL} sekund."

        while true; do
          check_server || true

          sleep "$CHECK_INTERVAL"
        done
      '';
    };

  # ------------------------------------------------------------
  # Samostatná systemd služba pro každý server
  # ------------------------------------------------------------

  serverServices =
    lib.mapAttrs' (
      name: server: let
        worker = mkServerWorker name server;
      in
        lib.nameValuePair "server-unlock-${name}" {
          description = "Automatic LUKS Unlock - ${name}";

          after = [
            "network-online.target"
          ];

          wants = [
            "network-online.target"
          ];

          wantedBy = [
            "multi-user.target"
          ];

          serviceConfig = {
            Type = "simple";

            User = "root";
            Group = "root";

            ExecStart = "${worker}/bin/server-unlock-${name}";

            Restart = "always";
            RestartSec = 10;

            NoNewPrivileges = true;
            PrivateTmp = true;

            ProtectHome = "read-only";
            ProtectSystem = "strict";

            ReadOnlyPaths = [
              server.keyFile
              server.passwordFile
            ];

            TimeoutStartSec = 0;
            KillMode = "control-group";
          };
        }
    )
    cfg.servers;
in {
  # ============================================================
  # OPTIONS
  # ============================================================

  options.services.serverUnlock = {
    enable = lib.mkEnableOption "Automatic LUKS Unlock Manager";

    servers = lib.mkOption {
      type = lib.types.attrsOf serverType;
      default = {};
      description = "Seznam serverů spravovaných VPS.";
    };

    checkInterval = lib.mkOption {
      type = lib.types.ints.positive;
      default = 300;
      description = "Interval pravidelné kontroly serveru v sekundách.";
    };

    bootTimeout = lib.mkOption {
      type = lib.types.ints.positive;
      default = 600;
      description = "Maximální čekání na běžné SSH po odemčení.";
    };

    bootPollInterval = lib.mkOption {
      type = lib.types.ints.positive;
      default = 5;
      description = "Interval kontroly běžného SSH během startu.";
    };

    unlockTimeout = lib.mkOption {
      type = lib.types.ints.positive;
      default = 900;
      description = "Maximální doba běhu SSH příkazu pro odemčení.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];

      default = "info";
      description = "Úroveň logování.";
    };
  };

  # ============================================================
  # CONFIGURATION
  # ============================================================

  config = lib.mkIf cfg.enable {
    assertions =
      [
        {
          assertion = cfg.servers != {};
          message = "services.serverUnlock: musí být nakonfigurován alespoň jeden server.";
        }
      ]
      ++ lib.mapAttrsToList (name: server: {
        assertion = server.hostPublicKey != "";
        message = "services.serverUnlock.servers.${name}.hostPublicKey nesmí být prázdný.";
      })
      cfg.servers
      ++ lib.mapAttrsToList (name: server: {
        assertion =
          builtins.match "[a-zA-Z0-9_.-]+" name != null;
        message = "Neplatný název serveru pro server-unlock: ${name}";
      })
      cfg.servers;

    # SSH host keys všech spravovaných initrd serverů.
    programs.ssh.knownHosts = serverKnownHosts;

    # Každý server má vlastní systemd službu.
    systemd.services = serverServices;
  };
}
