{
  config,
  ...
}:

let
  jellyfinDataDir =
    "${config.home.homeDirectory}/.application-data/jellyfin";
in
{
  imports = [
    ./launcher.nix
  ];

  # ------------------------------------------------------------
  # Jellyfin – uživatelská data
  # ------------------------------------------------------------

  home.activation.jellyfinDirectories =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${jellyfinDataDir}"
      mkdir -p "${jellyfinDataDir}/.config"
      mkdir -p "${jellyfinDataDir}/.local/share"
      mkdir -p "${jellyfinDataDir}/.cache"
    '';

  home.file = {
    ".config/jellyfin-desktop".source =
      config.lib.file.mkOutOfStoreSymlink
        "${jellyfinDataDir}/.config";

    ".local/share/jellyfin-desktop".source =
      config.lib.file.mkOutOfStoreSymlink
        "${jellyfinDataDir}/.local/share";

    ".cache/jellyfin-desktop".source =
      config.lib.file.mkOutOfStoreSymlink
        "${jellyfinDataDir}/.cache";
  };
}
