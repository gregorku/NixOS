{ config, pkgs, lib, ... }:

{
  # ----------------------
  # NetworkManager
  # ----------------------
  networking.networkmanager.enable = true;
  networking.useNetworkd = false;

  # ----------------------
  # mDNS / Service discovery
  # ----------------------
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # ----------------------
  # Síťové nástroje a VPN
  # ----------------------
  environment.systemPackages = with pkgs; [
    networkmanager
    wireguard-tools
    psmisc
    avahi
    openconnect
    vpn-slice
  ];

  # ----------------------
  # Uživatel může spravovat síť
  # ----------------------
  users.users.gregor.extraGroups = [ "networkmanager" ];
}