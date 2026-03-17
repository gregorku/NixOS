{ config, pkgs, lib, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  hardware.graphics.enable = true;

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.kio-extras
    kdePackages.kio-fuse
  ];
}