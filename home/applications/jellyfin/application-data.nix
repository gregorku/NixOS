{ config, ... }:

#
# Přesměrování uživatelských dat aplikace.
#
# Cíl:
#
# ~/.application-data/
# └── jellyfin/
#     ├── .config
#     ├── .local/share
#     └── .cache
#
# Aplikace stále používá standardní XDG umístění,
# ale fyzická data jsou uložena zde.
#

let
  appDir = "${config.home.homeDirectory}/.application-data/jellyfin";
in
{
  #
  # vytvoření adresářů
  #

  home.activation.jellyfinDirectories =
    config.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${appDir}/.config"
      mkdir -p "${appDir}/.local/share"
      mkdir -p "${appDir}/.cache"
    '';

  #
  # symlinky
  #

  home.file.".config/jellyfin-desktop".source =
    config.lib.file.mkOutOfStoreSymlink
      "${appDir}/.config";

  home.file.".local/share/jellyfin-desktop".source =
    config.lib.file.mkOutOfStoreSymlink
      "${appDir}/.local/share";

  home.file.".cache/jellyfin-desktop".source =
    config.lib.file.mkOutOfStoreSymlink
      "${appDir}/.cache";
}