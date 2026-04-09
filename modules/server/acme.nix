{ config, lib, ... }:

{
  options.my.acme.enable = lib.mkEnableOption "ACME";

  config = lib.mkIf config.my.acme.enable {

    security.acme.certs = {
      "gregor.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
      "vault.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
      "zabbix.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
      "homeassistant.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
      "homeassistant.serveftp.net" = { webroot = "/var/lib/acme/challenges"; };
      "grafana.serveftp.org" = { webroot = "/var/lib/acme/challenges"; };
    };
  };
}