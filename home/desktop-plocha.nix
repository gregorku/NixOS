{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./nabidka-kde.nix
  ];
}