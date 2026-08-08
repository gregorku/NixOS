{ config, lib, pkgs, ... }:

let
  cfg = config.services.serverUnlock;


  # ─────────────────────────────────────
  # Typ konfigurace jednoho serveru
  # ─────────────────────────────────────

  serverType = lib.types.submodule {
    options = {

      host = lib.mkOption {
        type = lib.types.str;

        description = ''
          IP adresa nebo hostname cíle dostupného z VPS.

          V našem případě jde o VPN adresu MikroTik routeru,
          přes který jsou porty přesměrovány na jednotlivé
          servery.
        '';
      };


      unlockPort = lib.mkOption {
        type = lib.types.port;

        description = ''
          SSH port initrd používaný pro vzdálené
          odemykání LUKS.
        '';
      };


      normalPort = lib.mkOption {
        type = lib.types.port;

        description = ''
          Produkční SSH port serveru.

          Tento port se používá pro kontrolu,
          zda je server již normálně spuštěný.
        '';
      };


      hostPublicKey = lib.mkOption {
        type = lib.types.str;

        description = ''
          Veřejný SSH host key initrd SSH serveru.

          Používá se pro deklarativní vytvoření
          systémového SSH known_hosts na VPS.

          Příklad:

            ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...
        '';
      };


      keyFile = lib.mkOption {
        type = lib.types.str;

        default = "/root/.ssh/unlock_servers";

        description = ''
          Soukromý SSH klíč používaný VPS serverem
          pro připojení k SSH serveru v initrd.
        '';
      };


      passwordFile = lib.mkOption {
        type = lib.types.str;

        description = ''
          Soubor obsahující LUKS passphrase.

          Soubor nesmí být uložen v Git repozitáři.

          Doporučené umístění:

            /etc/secrets/server-unlock/<server>.pass

          Doporučená práva:

            owner: root
            mode: 0400
        '';
      };

    };
  };


  # ─────────────────────────────────────
  # Kontrola jednoho serveru
  # ─────────────────────────────────────

  serverChecks =
    lib.concatStringsSep "\n"
      (
        lib.mapAttrsToList
          (
            name: server: ''

              check_server \
                ${lib.escapeShellArg name} \
                ${lib.escapeShellArg server.host} \
                ${toString server.unlockPort} \
                ${toString server.normalPort} \
                ${lib.escapeShellArg server.keyFile} \
                ${lib.escapeShellArg server.passwordFile}

            ''
          )
          cfg.servers
      );


  # ─────────────────────────────────────
  # Deklarativní SSH known_hosts
  # ─────────────────────────────────────

  serverKnownHosts =
    lib.mapAttrs'
      (
        name: server:
          lib.nameValuePair
            "${name}-initrd"
            {
              hostNames = [
                "[${server.host}]:${toString server.unlockPort}"
              ];

              publicKey = server.hostPublicKey;
            }
      )
      cfg.servers;


  # ─────────────────────────────────────
  # Program server-unlock
  # ─────────────────────────────────────

  serverUnlockScript = pkgs.writeShellApplication {

    name = "server-unlock";


    runtimeInputs = with pkgs; [
      bash
      coreutils
      gnugrep
      netcat-openbsd
      openssh
    ];


    text = ''
      set -u


      CHECK_INTERVAL=${toString cfg.checkInterval}
      BOOT_TIMEOUT=${toString cfg.bootTimeout}
      LOG_LEVEL=${lib.escapeShellArg cfg.logLevel}


      log()
      {
        local level="$1"
        shift

        printf '%s [%s] %s\n' \
          "$(date '+%Y-%m-%d %H:%M:%S')" \
          "$level" \
          "$*"
      }


      port_open()
      {
        local host="$1"
        local port="$2"

        nc \
          -z \
          -w 3 \
          "$host" \
          "$port" \
          >/dev/null 2>&1
      }


      wait_for_normal_ssh()
      {
        local name="$1"
        local host="$2"
        local port="$3"

        local waited=0

        log INFO \
          "$name: čekám na produkční SSH port $port"


        while (( waited < BOOT_TIMEOUT )); do

          if port_open "$host" "$port"; then

            log INFO \
              "$name: server úspěšně naběhl"

            return 0

          fi


          sleep "$CHECK_INTERVAL"

          waited=$((waited + CHECK_INTERVAL))

        done


        log ERROR \
          "$name: produkční SSH port se neobjevil během timeoutu"

        return 1
      }


      unlock_server()
      {
        local name="$1"
        local host="$2"
        local unlock_port="$3"
        local normal_port="$4"
        local ssh_key="$5"
        local password_file="$6"

        local ssh_status=0


        if [[ ! -r "$password_file" ]]; then

          log ERROR \
            "$name: nelze číst password file $password_file"

          return 1

        fi


        if [[ ! -r "$ssh_key" ]]; then

          log ERROR \
            "$name: nelze číst SSH klíč $ssh_key"

          return 1

        fi


        log INFO \
          "$name: initrd SSH je dostupné na portu $unlock_port"


        log INFO \
          "$name: pokouším se odemknout LUKS"


        #
        # systemd-tty-ask-password-agent očekává terminál.
        #
        # SSH proto používá -tt.
        #
        # Passphrase se čte pouze z lokálního souboru
        # na VPS a posílá se do vzdáleného initrd SSH.
        #
        # Po úspěšném odemčení initrd zanikne a SSH
        # spojení může skončit návratovým kódem != 0.
        #
        # Návratový kód SSH proto zaznamenáme,
        # ale skutečný výsledek ověříme podle stavu
        # produkčního a initrd SSH portu.
        #

        if ssh \
          -tt \
          -i "$ssh_key" \
          -p "$unlock_port" \
          -o BatchMode=yes \
          -o ConnectTimeout=10 \
          -o ConnectionAttempts=1 \
          root@"$host" \
          systemd-tty-ask-password-agent \
          < "$password_file"
        then

          ssh_status=0

        else

          ssh_status=$?

        fi


        if (( ssh_status == 0 )); then

          log INFO \
            "$name: SSH příkaz pro odemčení skončil úspěšně"

        else

          log WARN \
            "$name: SSH spojení skončilo s návratovým kódem $ssh_status"

        fi


        #
        # Krátká prodleva umožní initrd po úspěšném
        # odemčení ukončit SSH a pokračovat v bootu.
        #

        sleep 3


        #
        # 1. Produkční SSH už odpovídá.
        #
        # Server úspěšně naběhl.
        #

        if port_open "$host" "$normal_port"; then

          log INFO \
            "$name: server úspěšně naběhl"

          return 0

        fi


        #
        # 2. Initrd SSH stále odpovídá.
        #
        # Odemčení pravděpodobně selhalo.
        #
        # Vrátíme chybu a hlavní smyčka provede
        # další pokus po CHECK_INTERVAL.
        #

        if port_open "$host" "$unlock_port"; then

          log WARN \
            "$name: initrd SSH je stále dostupné, odemčení pravděpodobně selhalo"

          return 1

        fi


        #
        # 3. Initrd SSH už zmizelo a produkční SSH
        # zatím ještě není dostupné.
        #
        # Server pravděpodobně pokračuje v bootu.
        #

        log INFO \
          "$name: initrd SSH již není dostupné, čekám na produkční SSH"


        wait_for_normal_ssh \
          "$name" \
          "$host" \
          "$normal_port"
      }


      check_server()
      {
        local name="$1"
        local host="$2"
        local unlock_port="$3"
        local normal_port="$4"
        local ssh_key="$5"
        local password_file="$6"


        #
        # 1. Produkční SSH odpovídá.
        #
        # Server je již spuštěný.
        #

        if port_open "$host" "$normal_port"; then

          if [[ "$LOG_LEVEL" == "debug" ]]; then

            log DEBUG \
              "$name: server běží, SSH port $normal_port je dostupný"

          fi

          return 0

        fi


        #
        # 2. Produkční SSH neodpovídá.
        #
        # Zkontrolujeme initrd SSH.
        #

        if port_open "$host" "$unlock_port"; then

          unlock_server \
            "$name" \
            "$host" \
            "$unlock_port" \
            "$normal_port" \
            "$ssh_key" \
            "$password_file"

          return $?

        fi


        #
        # 3. Není dostupné produkční SSH
        #    ani initrd SSH.
        #
        # Server může být:
        #
        #   • vypnutý
        #   • bez napájení
        #   • bez sítě
        #   • právě v průběhu bootu
        #

        if [[ "$LOG_LEVEL" == "debug" ]]; then

          log DEBUG \
            "$name: nedostupné produkční i initrd SSH"

        fi

        return 0
      }


      log INFO \
        "Automatic LUKS Unlock Manager spuštěn"


      while true; do

        ${serverChecks}

        sleep "$CHECK_INTERVAL"

      done
    '';
  };


in
{

  # ─────────────────────────────────────
  # Options
  # ─────────────────────────────────────

  options.services.serverUnlock = {


    enable = lib.mkEnableOption
      "Automatic LUKS Unlock Manager";


    servers = lib.mkOption {

      type = lib.types.attrsOf serverType;

      default = { };

      description = ''
        Seznam serverů spravovaných službou
        Automatic LUKS Unlock Manager.
      '';
    };


    checkInterval = lib.mkOption {

      type = lib.types.ints.positive;

      default = 10;

      description = ''
        Interval kontroly serverů v sekundách.
      '';
    };


    unlockTimeout = lib.mkOption {

      type = lib.types.ints.positive;

      default = 900;

      description = ''
        Rezervovaná hodnota maximální doby čekání
        na initrd SSH.

        Výchozí hodnota je 900 sekund.
      '';
    };


    bootTimeout = lib.mkOption {

      type = lib.types.ints.positive;

      default = 600;

      description = ''
        Maximální doba čekání na produkční SSH
        po pokusu o odemčení LUKS.

        Výchozí hodnota je 600 sekund.
      '';
    };


    logLevel = lib.mkOption {

      type = lib.types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];

      default = "info";

      description = ''
        Úroveň logování služby server-unlock.
      '';
    };

  };


  # ─────────────────────────────────────
  # Configuration
  # ─────────────────────────────────────

  config = lib.mkIf cfg.enable {


    # ─────────────────────────────────────
    # Kontrola konfigurace
    # ─────────────────────────────────────

    assertions =
      lib.mapAttrsToList
        (
          name: server: {
            assertion =
              server.hostPublicKey != "";

            message =
              "services.serverUnlock.servers.${name}.hostPublicKey nesmí být prázdný";
          }
        )
        cfg.servers;


    # ─────────────────────────────────────
    # Deklarativní SSH known_hosts
    # ─────────────────────────────────────

    programs.ssh.knownHosts =
      serverKnownHosts;


    # ─────────────────────────────────────
    # Program
    # ─────────────────────────────────────

    environment.systemPackages = [
      serverUnlockScript
    ];


    # ─────────────────────────────────────
    # Hlavní konfigurace služby
    # ─────────────────────────────────────

    environment.etc."server-unlock/server-unlock.conf".text = ''
      CHECK_INTERVAL=${toString cfg.checkInterval}
      UNLOCK_TIMEOUT=${toString cfg.unlockTimeout}
      BOOT_TIMEOUT=${toString cfg.bootTimeout}
      LOG_LEVEL=${cfg.logLevel}
      SERVER_CONFIG=/etc/server-unlock/servers.conf
    '';


    # ─────────────────────────────────────
    # Seznam serverů
    # ─────────────────────────────────────

    environment.etc."server-unlock/servers.conf".text =
      lib.concatStringsSep "\n"
        (
          lib.mapAttrsToList
            (
              name: server: ''
                [${name}]
                HOST=${server.host}
                UNLOCK_PORT=${toString server.unlockPort}
                NORMAL_PORT=${toString server.normalPort}
                SSH_KEY=${server.keyFile}
                PASSWORD_FILE=${server.passwordFile}
              ''
            )
            cfg.servers
        );


    # ─────────────────────────────────────
    # systemd service
    # ─────────────────────────────────────

    systemd.services.server-unlock = {

      description =
        "Automatic Server LUKS Unlock Manager";


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

        Restart = "always";

        RestartSec = 10;

        ExecStart =
          "${serverUnlockScript}/bin/server-unlock";


        # Bezpečnostní omezení služby

        NoNewPrivileges = true;

        PrivateTmp = true;

        ProtectHome = "read-only";

        ProtectSystem = "strict";


        # Přístup k SSH klíči a LUKS password files

        ReadOnlyPaths = [
          "/root/.ssh"
          "/etc/secrets/server-unlock"
        ];

      };

    };

  };
}