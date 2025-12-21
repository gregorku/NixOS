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
    openFirewall = true;

    ## Automatické odhlášení (bezpečnost)
    settings = {
      Session = {
        IdleTimeout = 15;
      };
    };
  };

  ## =========================
  ## Cockpit balíček
  ## =========================
  environment.systemPackages = with pkgs; [
    cockpit
  ];
}
