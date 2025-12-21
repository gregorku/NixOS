{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = false;  # Firewall je vypnutý, ale pro úplnost


  # KLÍČOVÉ: Explicitně definovat socket v NixOS stylu
  systemd.sockets.cockpit = {
    enable = true;
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      # TOTO JE NEJDŮLEŽITĚJŠÍ - přinutí IPv4 naslouchání
      ListenStream = [ "0.0.0.0:9090" ];
      # Pro IPv6 přidejte: "[::]:9090"
    };
  };
}
