{ config, pkgs, ... }:

{
  ## =========================
  ## Cockpit – Web UI pro server
  ## =========================

  services.cockpit = {
    enable = true;

    ## DŮLEŽITÉ: explicitně určit balíček Cockpitu
    ## (jinak se nespustí cockpit-ws backend)
    package = pkgs.cockpit;

    port = 9090;
    openFirewall = true;

    settings = {
      Session = {
        IdleTimeout = 15;
      };
    };
  };

  ## =========================
  ## Nutné služby (už máš, ale zde pro úplnost)
  ## =========================
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  services.dbus.enable = true;

  ## =========================
  ## NEpřidávat cockpit do systemPackages
  ## =========================
}
