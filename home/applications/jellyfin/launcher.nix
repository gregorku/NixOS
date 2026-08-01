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

  home.file.".local/share/applications/org.jellyfin.JellyfinDesktop.desktop".text =
    builtins.replaceStrings
      [ "Exec=jellyfin-desktop" ]
      [ "Exec=jellyfin" ]
      (builtins.readFile
        "${pkgs.jellyfin-media-player}/share/applications/org.jellyfin.JellyfinDesktop.desktop");
}