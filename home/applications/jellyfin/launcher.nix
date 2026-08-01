{ config, pkgs, ... }:

let
  jellyfin = pkgs.writeShellScriptBin "jellyfin" ''
    exec nvidia-offload ${pkgs.jellyfin-media-player}/bin/jellyfin-desktop "$@"
  '';
in
{
  home.packages = [
    pkgs.jellyfin-media-player
    jellyfin
  ];

#
# Převzetí originálního .desktop souboru.
#
# Zachová:
#   • ikony
#   • překlady
#   • MIME asociace
#   • AppStream metadata
#
# Mění pouze Exec= tak, aby se používal wrapper.
#

  home.file.".local/share/applications/org.jellyfin.JellyfinDesktop.desktop".text =
    builtins.replaceStrings
      [ "Exec=jellyfin-desktop" ]
      [ "Exec=jellyfin" ]
      (builtins.readFile
        "${pkgs.jellyfin-media-player}/share/applications/org.jellyfin.JellyfinDesktop.desktop");
}