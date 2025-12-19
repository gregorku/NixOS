{ config, pkgs, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;

    # Odstranit allowed-origins pro přímé připojení (pokud nepoužíváte reverse proxy)
    # allowed-origins = [ "https://cockpit.<domain>.com" ];  # ZAKOMENTOVÁNO

    settings = {
      WebService = {
        AllowUnencrypted = true;  # Povolit HTTP pro testování

        # Naslouchat na všech adresách (IPv4 i IPv6)
        # Pokud chcete povolit pouze HTTP (bez HTTPS), přidejte:
        # ProtocolHeader = "";  # Prázdné pro přímé připojení
      };
    };
  };

  # Vynutit naslouchání na všech síťových rozhraních (IPv4 i IPv6)
  systemd.sockets.cockpit.socketConfig = {
    ListenStream = [
      "0.0.0.0:9090"   # IPv4 na všech adresách
      "[::]:9090"      # IPv6 na všech adresách
    ];
  };
}
