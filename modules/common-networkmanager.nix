{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanager
    networkmanagerapplet

    # VPN pluginy
    networkmanager-openvpn
    networkmanager-openconnect

    # WireGuard nástroje (CLI + NM backend)
    wireguard-tools
  ];

  programs.nm-applet.enable = true;

  # uživatel smí spravovat síť
  users.users.gregor.extraGroups = [ "networkmanager" ];
}
