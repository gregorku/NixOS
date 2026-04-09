{ config, lib, pkgs, ... }:

{
  options.my.security.testMode = lib.mkEnableOption "Test mode";

  config = lib.mkIf config.my.security.testMode {

    # otevři víc portů pro debug
    networking.firewall.allowedTCPPorts = [ 80 443 8404 3000 8080 ];

    # vypni fail2ban (neotravuje při testu)
    services.fail2ban.enable = false;

    # ACME staging (!!! důležité)
    security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

    # verbose logging
    services.haproxy.extraConfig = ''
      debug
    '';
  };
}