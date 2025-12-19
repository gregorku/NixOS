{ config, pkgs, ... }:

{
  services.cockpit.enable = true;

  # Firewall teď neřešíme
  services.cockpit.openFirewall = true;

  # KONFIGURACE SOCKETU (KLÍČOVÉ)
  systemd.sockets."cockpit" = {
    listenStreams = [
      "0.0.0.0:9090"
      "[::]:9090"
    ];
    wantedBy = [ "sockets.target" ];
  };
}
