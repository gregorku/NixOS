{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = false;  # Firewall je vypnutý, ale pro úplnost

    # Odstranit všechny omezení pro přístup
    settings = {
      WebService = {
        AllowUnencrypted = true;
        # Použijte mkForce k přepsání výchozí hodnoty
        Origins = lib.mkForce "*";
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
    };
  };

  # Zajistit, že socket bude spuštěn před službou
  systemd.services.cockpit = {
    requires = [ "cockpit.socket" ];
    after = [ "cockpit.socket" ];
  };
}
