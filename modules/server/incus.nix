{ config, pkgs, lib, ... }:
{
  virtualisation.incus = {
    enable    = true;
    ui.enable = true;   # webové UI (přístupné přes Cockpit nebo přímo)
  };

  # Skupina pro neprivilegovaný přístup k Incus
  users.groups.incus-admin = {};

  environment.systemPackages = with pkgs; [
    incus
  ];

  # Po instalaci spusťte ručně:
  #   sudo incus admin init
  #
  # Doporučené volby při `incus admin init`:
  #   Storage backend:  dir   (jednoduché, spolehlivé na VPS)
  #   Storage path:     /var/lib/incus/storage-pools/default
  #   Network bridge:   incusbr0
  #   Bridge IP:        10.10.10.1/24
  #   NAT:              yes
  #   IPv6:             none
}