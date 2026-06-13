{ config, pkgs, ... }:

{
  # 1. Aktivace vestavěné podpory RDP v KDE Plasma 6
  services.krdp = {
    enable = true;
    openFirewall = false; # Pravidla firewallu řešíme níže
  };

  # 2. Nastavení firewallu (nftables) s restrikcí na rozsah vaší VPN
  networking.firewall = {
    enable = true;

    # Správný parametr pro nftables pravidla do řetězce input
    extraInputRules = ''
      # Povolit RDP (TCP i UDP) pouze z VPN rozsahu
      ip saddr 120.100.100.0/24 tcp dport 3389 accept
      ip saddr 120.100.100.0/24 udp dport 3389 accept

      # Povolit SSH (TCP 22) pouze z VPN rozsahu
      ip saddr 120.100.100.0/24 tcp dport 22 accept
    '';
  };
}