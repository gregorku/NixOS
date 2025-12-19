{ config, pkgs, lib, ... }:

{
  networking.networkmanager.enable = true;

  # Explicitně zakázat systemd-networkd
  networking.useNetworkd = false;
  systemd.services.systemd-networkd.enable = false;
  systemd.sockets.systemd-networkd.enable = false;

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
