{ config, pkgs, ... }:

{
  # 1. Přidání KRDP klienta/serveru do systémových balíčků
  environment.systemPackages = with pkgs; [
    kdePackages.krdp
  ];

  # 2. Nastavení firewallu (nftables) – povolení portů pouze z VPN rozsahu
  networking.firewall = {
    enable = true;

    extraInputRules = ''
      # Povolit RDP (TCP i UDP) pouze z VPN rozsahu pro KDE Plasma
      ip saddr 120.100.100.0/24 tcp dport 3389 accept
      ip saddr 120.100.100.0/24 udp dport 3389 accept

      # Povolit SSH (TCP 22) pouze z VPN rozsahu
      ip saddr 120.100.100.0/24 tcp dport 22 accept
    '';
  };
}