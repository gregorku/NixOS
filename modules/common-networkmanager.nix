{ config, pkgs, lib, ... }:

{
  networking.networkmanager.enable = true;

  # Vynutit DHCP jako výchozí
  networking.useDHCP = lib.mkForce true;

  # Zakázat ruční konfiguraci
  networking.dhcpcd.enable = false;
  networking.interfaces = {};

  environment.systemPackages = with pkgs; [
    networkmanager
    networkmanagerapplet
    wireguard-tools
  ];

  programs.nm-applet.enable = true;

  # uživatel smí spravovat síť
  users.users.gregor.extraGroups = [ "networkmanager" ];
}
