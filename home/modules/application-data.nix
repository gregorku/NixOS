{ config, lib, ... }:

with lib;

let
  cfg = config.my.applicationData;
  appDir = "${config.home.homeDirectory}/.application-data/${cfg.name}";
in
{
  options.my.applicationData = {
    enable = mkEnableOption "Application data redirection";

    name = mkOption {
      type = types.str;
      description = "Application name.";
    };

    configDir = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    dataDir = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    cacheDir = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {

    home.activation.applicationData =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "${appDir}"

        ${optionalString (cfg.configDir != null) ''
          mkdir -p "${appDir}/.config"
        ''}

        ${optionalString (cfg.dataDir != null) ''
          mkdir -p "${appDir}/.local/share"
        ''}

        ${optionalString (cfg.cacheDir != null) ''
          mkdir -p "${appDir}/.cache"
        ''}
      '';

    home.file = mkMerge [

      (mkIf (cfg.configDir != null) {
        ".config/${cfg.configDir}".source =
          config.lib.file.mkOutOfStoreSymlink
            "${appDir}/.config";
      })

      (mkIf (cfg.dataDir != null) {
        ".local/share/${cfg.dataDir}".source =
          config.lib.file.mkOutOfStoreSymlink
            "${appDir}/.local/share";
      })

      (mkIf (cfg.cacheDir != null) {
        ".cache/${cfg.cacheDir}".source =
          config.lib.file.mkOutOfStoreSymlink
            "${appDir}/.cache";
      })
    ];
  };
}