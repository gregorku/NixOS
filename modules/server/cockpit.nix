{ config, pkgs, lib, ... }:

{
  ## =========================
  ## Cockpit – Web UI
  ## =========================
  services.cockpit = {
    enable = true;

    ## Default port
    port = 9090;

    ## Firewall řešíš jinde (LAN / router / VPN)
    openFirewall = false;
  };

  ## =========================
  ## OPRAVA: socket pouze na IPv4
  ## =========================
  systemd.sockets.cockpit = {
    enable = true;
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ## Kritické: vynutit IPv4 listen
      ListenStream = [ "0.0.0.0:9090" ];
    };
  };
}
