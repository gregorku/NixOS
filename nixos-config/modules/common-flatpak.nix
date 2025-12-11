{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  };

  services.flatpak.remotes = {
    flathub = {
      url = "https://flathub.org/repo/flathub.flatpakrepo";
      gpgVerify = false;
    };
  };
}
