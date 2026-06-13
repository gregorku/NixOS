{ config, pkgs, ... }:

{
  # 1. Balíček pro nativní VNC server v KDE Plasma 6
  environment.systemPackages = with pkgs; [
    kdePackages.krfb
  ];

  # 2. Nastavení firewallu pro vaši Mikrotik VPN
  networking.firewall = {
    enable = true;

    extraInputRules = ''
      # Povolit SSH (port 22) z VPN
      ip saddr 120.100.100.0/24 tcp dport 22 accept

      # Povolit VNC (port 5900) z VPN pro krfb
      ip saddr 120.100.100.0/24 tcp dport 5900 accept
    '';
  };
}