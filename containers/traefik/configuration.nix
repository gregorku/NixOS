{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";

  networking = {
    hostName = "traefik";
    useDHCP = false;

    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.100.231";
      prefixLength = 24;
    }];

    defaultGateway = "192.168.100.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    firewall.allowedTCPPorts = [ 443 8888 ];
  };

  services.traefik = {
    enable = true;
    environmentFiles = [ "/run/secrets/traefik/env" ];

    staticConfigOptions = {
      entryPoints = {
        websecure.address = ":443";
        admin.address = ":8888";
      };

      api.dashboard = true;

      certificatesResolvers.cloudflare.acme = {
        email = "admin@homeassistant.serveftp.org";
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          delayBeforeCheck = 10;
        };
      };

      experimental.plugins.crowdsec = {
        moduleName = "github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin";
        version = "v1.4.2";
      };
    };

    dynamicConfigOptions.http = {
      routers = {
        ha = {
          rule = "Host(`homeassistant.serveftp.org`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "cloudflare";
          service = "ha";
          middlewares = [ "crowdsec" ];
        };

        traefik = {
          rule = "Host(`traefik.lan`)";
          entryPoints = [ "admin" ];
          service = "api@internal";
          middlewares = [ "lan-only" ];
        };
      };

      services.ha.loadBalancer.servers = [
        { url = "http://192.168.100.230:8123"; }
      ];

      middlewares = {
        lan-only.ipWhiteList.sourceRange = [
          "192.168.100.0/24"
          "120.100.100.0/24"
        ];

        crowdsec.plugin.crowdsec = {
          enabled = true;
          logLevel = "INFO";
        };
      };
    };
  };

  services.crowdsec = {
    enable = true;
    webUi.enable = true;
    environmentFiles = [ "/run/secrets/crowdsec/env" ];
  };

  services.crowdsec.bouncers.traefik.enable = true;
}
