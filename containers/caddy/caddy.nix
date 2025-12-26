{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    email = "gregorku@zohomail.eu"; # Nastavte svůj email pro Let's Encrypt

    virtualHosts = {
      "homeassistant.serveftp.org" = {
        extraConfig = ''
          encode gzip
          reverse_proxy http://192.168.100.230:8123 {
            header_up Host {host}
            header_up X-Real-IP {remote}
            header_up X-Forwarded-For {remote}
            header_up X-Forwarded-Proto {scheme}
          }
        '';
      };

      # Můžete přidat i subdoménu pro homeassistant
      "homeassistant.homeassistant.serveftp.org" = {
        extraConfig = ''
          encode gzip
          reverse_proxy http://192.168.100.230:8123 {
            header_up Host {host}
            header_up X-Real-IP {remote}
            header_up X-Forwarded-For {remote}
            header_up X-Forwarded-Proto {scheme}
          }
        '';
      };
    };
  };

  # Povolit porty v firewallu
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
