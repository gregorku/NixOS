{ pkgs, ... }:

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

  xdg.desktopEntries.jellyfin = {
    name = "Jellyfin";
    exec = "jellyfin";
    icon = "jellyfinmediaplayer";
    terminal = false;
    type = "Application";
    categories = [ "AudioVideo" "Video" ];
  };
}