{ config, pkgs, ... }:

{
  services.cockpit = {
    enable = true;
    openFirewall = true; [cite: 1]
    settings = {
      WebService = {
        AllowUnencrypted = true;
        # Toto pomůže, pokud prohlížeč blokuje mix HTTP/HTTPS
        ProtocolHeader = "X-Forwarded-Proto";
      };
      # Přidání této sekce může pomoci s přihlašovací smyčkou
      Session = {
        IdleTimeout = 15;
        Banner = "/etc/issue";
      };
    };
  };

  # Ujistěte se, že Cockpit má přístup k PAM
  security.pam.services.cockpit = {};
}
