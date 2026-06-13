# common-remote-access.nix
# Modul pro vzdálený přístup přes RDP přes VPN (MikroTik port forwarding)
# Použití: imports = [ ./common-remote-access.nix ];

{ config, lib, pkgs, ... }:

{
  # ────────────────────────────────────────────
  # xrdp – vzdálená plocha
  # ────────────────────────────────────────────
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
    openFirewall = false;
  };

  # Vynutit X11 session pro xrdp
  services.displayManager.defaultSession = "plasmax11";

  # ────────────────────────────────────────────
  # Firewall – RDP pouze z VPN rozsahu
  # ────────────────────────────────────────────
  networking.firewall.extraCommands = ''
    iptables -A INPUT -s 120.100.100.0/24 -p tcp --dport 3389 -j ACCEPT
  '';

  networking.firewall.extraStopCommands = ''
    iptables -D INPUT -s 120.100.100.0/24 -p tcp --dport 3389 -j ACCEPT || true
  '';
}
