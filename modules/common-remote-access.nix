# common-remote-access.nix
# Modul pro vzdálený přístup přes KRDP (nativní KDE Wayland RDP)
# Použití: imports = [ ./common-remote-access.nix ];

{ config, lib, pkgs, ... }:

{
  # KRDP binárka dostupná v systému
  environment.systemPackages = [ pkgs.kdePackages.krdp ];

  # Firewall – RDP pouze z VPN rozsahu
  networking.firewall.extraCommands = ''
    iptables -A INPUT -s 120.100.100.0/24 -p tcp --dport 3389 -j ACCEPT
  '';

  networking.firewall.extraStopCommands = ''
    iptables -D INPUT -s 120.100.100.0/24 -p tcp --dport 3389 -j ACCEPT || true
  '';
}
