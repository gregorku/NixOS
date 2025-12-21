{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = false;
  };

  ## KLÍČOVÉ: Explicitně definovat socket (IPv4)
  systemd.sockets.cockpit = {
    enable = true;
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = [ "0.0.0.0:9090" ];
    };
  };
}
