{ config, pkgs, secretsPath, ... }:

{
  imports = [
    "${secretsPath}/traefik/default.nix"
  ];

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        websecure.address = ":443";
        admin.address = "192.168.100.1:8888";
      };

      api.dashboard = true;

      certificatesResolvers.cloudflare.acme = {
        email = "admin@tvoje-domena.cz";
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          delayBeforeCheck = 10;
        };
      };
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          ha = {
            rule = "Host(`homeassistant.serveftp.org`)";
            entryPoints = [ "websecure" ];
            tls.certResolver = "cloudflare";
            service = "ha";
            middlewares = [ "crowdsec@file" ];
          };

          traefik = {
            rule = "Host(`traefik.lan`)";
            entryPoints = [ "admin" ];
            service = "api@internal";
            middlewares = [ "lan-only" ];
          };

          crowdsec = {
            rule = "Host(`crowdsec.lan`)";
            entryPoints = [ "admin" ];
            service = "crowdsec";
            middlewares = [ "lan-only" ];
          };
        };

        services = {
          ha.loadBalancer.servers = [
            { url = "http://192.168.100.230:8123"; }
          ];

          crowdsec.loadBalancer.servers = [
            { url = "http://127.0.0.1:3000"; }
          ];
        };

        middlewares = {
          lan-only.ipWhiteList.sourceRange = [
            "192.168.100.0/24"
            "120.100.100.0/24"
          ];
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 443 ];
  networking.firewall.interfaces.eth0.allowedTCPPorts = [ 8888 ];
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 8888 ];
}
