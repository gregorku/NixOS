{ config, pkgs, ... }:

{
  ## =========================
  ## Cockpit – Web UI pro server
  ## =========================
  services.cockpit = {
    enable = true;

    ## Defaultní port Cockpitu
    port = 9090;

    ## Povolit přístup přes firewall (LAN)
    ## Skutečný dosah řeší síť / router
    openFirewall = true;

    ## Automatické odhlášení (bezpečnost)
    settings = {
      Session = {
        IdleTimeout = 15;
      };
    };
  };

  ## =========================
  ## Nutné systémové služby
  ## =========================

  ## Polkit – autorizace akcí (nutné pro Cockpit)
  security.polkit.enable = true;

  ## Accounts service – NUTNÉ pro přihlášení do Cockpitu
  services.accounts-daemon.enable = true;

  ## D-Bus – komunikace se systémem (většinou už běží)
  services.dbus.enable = true;

  ## =========================
  ## Volitelné, ale doporučené
  ## =========================

  ## Ujistit se, že cockpit backend binárky jsou dostupné
  ## (na serverových profilech to občas chybí v PATH)
  environment.systemPackages = with pkgs; [
    cockpit
  ];
}
