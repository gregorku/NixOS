{ config, pkgs, ... }:

{
  # 1. Balíček pro VNC server na Waylandu
  environment.systemPackages = with pkgs; [
    wayvnc
  ];

  # 2. Nastavení firewallu pro vaši Mikrotik VPN (120.100.100.0/24)
  networking.firewall = {
    enable = true;

    extraInputRules = ''
      # Povolit SSH (port 22) z VPN
      ip saddr 120.100.100.0/24 tcp dport 22 accept

      # Povolit VNC (port 5900) z VPN pro přenos plochy Waylandu
      ip saddr 120.100.100.0/24 tcp dport 5900 accept
    '';
  };
}