{ config, lib, ... }:

let
  applicationDataModule =
    { name, ... }:
    {
      options = {
        enable = lib.mkEnableOption "Application data redirection";

        configDir = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Directory under ~/.config.";
        };

        dataDir = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Directory under ~/.local/share.";
        };

        cacheDir = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Directory under ~/.cache.";
        };
      };
    };
in
{
  # ============================================================
  # Konfigurace jednotlivých aplikací
  #
  # Použití:
  #
  # my.applicationData.vscodium = {
  #   enable = true;
  #   configDir = "VSCodium";
  #   dataDir = "VSCodium";
  #   cacheDir = "VSCodium";
  # };
  #
  # ============================================================

  options.my.applicationData = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule applicationDataModule
    );

    default = {};

    description = ''
      Přesměrování uživatelských dat aplikací do
      ~/.application-data/<název-aplikace>.
    '';
  };

  # ============================================================
  # Vytvoření adresářů a symlinků
  # ============================================================

  config = {
    home.activation.applicationData =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList
            (
              name: app:
              lib.optionalString app.enable ''
                mkdir -p "${config.home.homeDirectory}/.application-data/${name}"

                ${lib.optionalString (app.configDir != null) ''
                  mkdir -p "${config.home.homeDirectory}/.application-data/${name}/.config"
                ''}

                ${lib.optionalString (app.dataDir != null) ''
                  mkdir -p "${config.home.homeDirectory}/.application-data/${name}/.local/share"
                ''}

                ${lib.optionalString (app.cacheDir != null) ''
                  mkdir -p "${config.home.homeDirectory}/.application-data/${name}/.cache"
                ''}
              ''
            )
            config.my.applicationData
        )}
      '';

    home.file = lib.mkMerge (
      lib.flatten (
        lib.mapAttrsToList
          (
            name: app:
            lib.optional app.enable (
              lib.mkMerge [
                (lib.mkIf (app.configDir != null) {
                  ".config/${app.configDir}".source =
                    config.lib.file.mkOutOfStoreSymlink
                      "${config.home.homeDirectory}/.application-data/${name}/.config";
                })

                (lib.mkIf (app.dataDir != null) {
                  ".local/share/${app.dataDir}".source =
                    config.lib.file.mkOutOfStoreSymlink
                      "${config.home.homeDirectory}/.application-data/${name}/.local/share";
                })

                (lib.mkIf (app.cacheDir != null) {
                  ".cache/${app.cacheDir}".source =
                    config.lib.file.mkOutOfStoreSymlink
                      "${config.home.homeDirectory}/.application-data/${name}/.cache";
                })
              ]
            )
          )
          config.my.applicationData
      )
    );
  };
}
