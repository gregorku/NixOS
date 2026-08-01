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
}