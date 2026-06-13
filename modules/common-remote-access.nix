# common-remote-access.nix
# Modul pro vzdálený přístup přes RDP přes VPN (MikroTik port forwarding)
# Použití: imports = [ ./common-remote-access.nix ];

{ config, lib, pkgs, ... }:

{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
    openFirewall = false;
  };

  # Test: spustit icewm místo KDE pro ověření funkčnosti xrdp
  # Po úspěšném testu přepnout zpět na startplasma-x11
  environment.etc."xrdp/startwm.sh" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      . /etc/profile
      exec ${pkgs.icewm}/bin/icewm-session
    '';
  };

  environment.systemPackages = [ pkgs.icewm ];

  # Firewall – RDP pouze z VPN rozsahu
  networking.firewall.extraCommands = ''
    iptables -A INPUT -s 120.100.100.0/24 -p tcp --dport 3389 -j ACCEPT
  '';

  networking.firewall.extraStopCommands = ''
    iptables -D INPUT -s 120.100.100.0/24 -p tcp --dport 3389 -j ACCEPT || true
  '';
}
