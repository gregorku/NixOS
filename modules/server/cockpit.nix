{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
  };

  systemd.sockets.cockpit = {
    enable = true;
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = [ "0.0.0.0:9090" ];
    };
  };
}
