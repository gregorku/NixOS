{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = false; # [cite: 19]

    settings = {
      WebService = {
        # Povoluje přístup z různých adres, což řeší chyby při přihlašování
        Origins = lib.mkForce "*"; #
        # Povoluje nešifrované připojení, pokud nepoužíváte vlastní certifikáty
        AllowUnencrypted = true; #
      };
    };
  };

  # Explicitní definice socketu řeší problém s nasloucháním v nspawn kontejneru
  systemd.sockets.cockpit = {
    enable = true;
    wantedBy = [ "sockets.target" ]; # [cite: 22]
    socketConfig = {
      ListenStream = [ "0.0.0.0:9090" ]; #
      SocketMode = "0666"; #
    };
  };

  # Zajištění správné posloupnosti spouštění
  systemd.services.cockpit = {
    requires = [ "cockpit.socket" ]; #
    after = [ "cockpit.socket" ]; #
  };
}
