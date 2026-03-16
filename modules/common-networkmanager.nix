{ config, pkgs, lib, ... }:

{
  # ----------------------
  # NetworkManager
  # ----------------------
  networking.networkmanager.enable = true;

  # Nepoužívat systemd-networkd
  networking.useNetworkd = false;

  # ----------------------
  # mDNS / Service discovery (tiskárny, skenery, AirPrint)
  # ----------------------
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # ----------------------
  # Síťové nástroje
  # ----------------------
  environment.systemPackages = with pkgs; [
    networkmanager
    wireguard-tools
    avahi
  ];

  # ----------------------
  # Uživatel může spravovat síť
  # ----------------------
  users.users.gregor.extraGroups = [ "networkmanager" ];
}
