{ config, pkgs, lib, ... }:

{
  # Použít NetworkManager
  networking.networkmanager.enable = true;

  # Nepoužívat systemd-networkd
  networking.useNetworkd = false;

  # Nástroje pro síť (server-friendly)
  environment.systemPackages = with pkgs; [
    networkmanager
    wireguard-tools
  ];

  # Uživatel může spravovat síť
  users.users.gregor.extraGroups = [ "networkmanager" ];
}
