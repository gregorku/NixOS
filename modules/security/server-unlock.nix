{ config, lib, pkgs, ... }:

let
  cfg = config.services.serverUnlock;
in
{

  options.services.serverUnlock = {

    enable = lib.mkEnableOption "Automatic LUKS Unlock Manager";

    package = lib.mkOption {
      type = lib.types.package;
      description = "server-unlock package";
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/server-unlock/servers.conf";
      description = "Server configuration file.";
    };

    checkInterval = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Server check interval in seconds.";
    };

    unlockTimeout = lib.mkOption {
      type = lib.types.int;
      default = 900;
      description = "Maximum wait for unlock port (seconds).";
    };

    bootTimeout = lib.mkOption {
      type = lib.types.int;
      default = 600;
      description = "Maximum wait for normal SSH (seconds).";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      cfg.package
    ];

    environment.etc."server-unlock/server-unlock.conf".text = ''
CHECK_INTERVAL=${toString cfg.checkInterval}
UNLOCK_TIMEOUT=${toString cfg.unlockTimeout}
BOOT_TIMEOUT=${toString cfg.bootTimeout}
LOG_LEVEL=${cfg.logLevel}
SERVER_CONFIG=${cfg.configFile}
'';

    systemd.services.server-unlock = {

      description = "Automatic Server Unlock Manager";

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

        Restart = "always";
        RestartSec = 5;

        ExecStart =
          "${cfg.package}/bin/server-unlock";

      };
    };

  };

}