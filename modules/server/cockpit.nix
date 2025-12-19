{ config, pkgs, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;

    # Odstranit všechny omezení pro přístup
    settings = {
      WebService = {
        AllowUnencrypted = true;
        # Odstranit ProtocolHeader pro přímé připojení
        Origins = "*";
      };
    };
  };

  # KLÍČOVÉ: Explicitně definovat socket v NixOS stylu
  systemd.sockets.cockpit = {
    enable = true;
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      # TOTO JE NEJDŮLEŽITĚJŠÍ - přinutí IPv4 naslouchání
      ListenStream = [ "0.0.0.0:9090" ];
      # Pro IPv6 přidejte: "[::]:9090"
      SocketMode = "0666";
      PassCredentials = true;
    };
  };

  # Zajistit, že socket bude spuštěn před službou
  systemd.services.cockpit = {
    requires = [ "cockpit.socket" ];
    after = [ "cockpit.socket" ];
  };
}
