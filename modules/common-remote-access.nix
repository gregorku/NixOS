{ config, pkgs, ... }:

{
  # 1. Aktivace vestavěné podpory RDP v KDE Plasma 6 (Wayland)
  services.krdp = {
    enable = true;
    openFirewall = false; # Pravidla firewallu si definujeme bezpečně sami níže
  };

  # 2. Nastavení firewallu s restrikcí na rozsah vaší VPN (120.100.100.0/24)
  networking.firewall = {
    enable = true;

    # Otevřeme porty pro RDP (3389) a SSH (22), ale POUZE z VPN rozsahu přes nftables
    extraRulesAfterHooks = ''
      table inet filter {
        chain input {
          # Povolit RDP (TCP i UDP) pouze z VPN rozsahu
          ip saddr 120.100.100.0/24 tcp dport 3389 accept
          ip saddr 120.100.100.0/24 udp dport 3389 accept

          # Povolit SSH (TCP 22) pouze z VPN rozsahu
          ip saddr 120.100.100.0/24 tcp dport 22 accept
        }
      }
    '';
  };
}