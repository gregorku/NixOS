{ config, lib, pkgs, ... }:

{
  options.my.security.enable = lib.mkEnableOption "Base security";

  config = lib.mkIf config.my.security.enable {

    # Firewall
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };

    # Fail2ban (doporučeno)
    services.fail2ban.enable = true;

    # základní hardening
    security.sudo.wheelNeedsPassword = true;

    # ACME (globální)
    security.acme = {
      acceptTerms = true;
      defaults.email = "gregorku@atlas.cz";

      defaults.postRun = ''
        systemctl reload haproxy
      '';
    };
  };
}