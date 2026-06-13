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

  # Přepsat startwm.sh s potřebnými environment proměnnými pro KDE
  environment.etc."xrdp/startwm.sh" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      . /etc/profile

      export DESKTOP_SESSION=plasma
      export XDG_SESSION_TYPE=x11
      export XDG_CURRENT_DESKTOP=KDE
      export XDG_CONFIG_DIRS=/etc/xdg
      export DBUS_SESSION_BUS_ADDRESS=$(dbus-launch --sh-syntax | grep DBUS_SESSION_BUS_ADDRESS | cut -d= -f2- | tr -d "';")

      exec startplasma-x11
    '';
  };

  # Firewall – RDP pouze z VPN rozsahu
  networking.firewall.extraCommands = ''
    iptables -A INPUT -s 120.100.100.0/24 -p tcp --dport 3389 -j ACCEPT
  '';

  networking.firewall.extraStopCommands = ''
    iptables -D INPUT -s 120.100.100.0/24 -p tcp --dport 3389 -j ACCEPT || true
  '';
}
