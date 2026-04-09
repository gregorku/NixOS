{ config, lib, pkgs, ... }:

{
  options.my.acme.enable = lib.mkEnableOption "ACME + nginx webroot";

  config = lib.mkIf config.my.acme.enable {

    # -------------------------
    # ACME (Let's Encrypt)
    # -------------------------
    security.acme = {
      acceptTerms = true;

      defaults = {
        email = "tvoje@email.cz";

        postRun = ''
          for d in /var/lib/acme/*; do
            name=$(basename $d)
            cat $d/fullchain.pem $d/key.pem > /etc/haproxy/certs/$name.pem
          done
          systemctl reload haproxy
        '';
      };

      certs = {
        "gregor.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
        "vault.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
        "zabbix.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
        "homeassistant.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
        "homeassistant.serveftp.net" = { webroot = "/var/lib/acme/challenges"; };
        "grafana.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
      };
    };

    # -------------------------
    # Nginx jen pro ACME
    # -------------------------
    services.nginx = {
      enable = true;

      virtualHosts."acme" = {
        root = "/var/lib/acme/challenges";

        listen = [
          { addr = "127.0.0.1"; port = 8080; }
        ];
      };
    };
  };
}