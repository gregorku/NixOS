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
    ## Internet ne – řeší firewall / síť
    openFirewall = true;

    ## Volitelné: automatické odhlášení (bezpečnost)
    settings = {
      Session = {
        IdleTimeout = 15;
      };
    };
  };

  ## =========================
  ## Cockpit balíčky
  ## =========================
  environment.systemPackages = with pkgs; [
    cockpit
    cockpit-machines   # správa libvirt / VM
  ];
}
