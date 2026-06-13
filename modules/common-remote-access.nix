# common-remote-access.nix
# Modul pro vzdálený přístup přes VNC (wayvnc) s Wayland/KDE Plasma
# Použití: imports = [ ./common-remote-access.nix ];

{ config, lib, pkgs, ... }:

{
  # ────────────────────────────────────────────
  # wayvnc – nativní Wayland VNC server
  # ────────────────────────────────────────────
  services.wayvnc = {
    enable = true;
    address = "0.0.0.0";
    port = 5900;
  };

  # ────────────────────────────────────────────
  # Firewall – VNC pouze z VPN rozsahu
  # ────────────────────────────────────────────
  networking.firewall.extraCommands = ''
    iptables -A INPUT -s 120.100.100.0/24 -p tcp --dport 5900 -j ACCEPT
  '';

  networking.firewall.extraStopCommands = ''
    iptables -D INPUT -s 120.100.100.0/24 -p tcp --dport 5900 -j ACCEPT || true
  '';
}
