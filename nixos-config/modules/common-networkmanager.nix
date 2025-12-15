{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanager
    networkmanagerapplet
    networkmanager-openvpn
    networkmanager-wireguard
  ];

  programs.nm-applet.enable = true;

  # uživatel smí spravovat síť
  users.users.gregor.extraGroups = [ "networkmanager" ];
}
