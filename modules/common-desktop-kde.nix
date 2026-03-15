{ config, pkgs, lib, ... }:

{
  # ======================
  # Display Manager
  # ======================
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # ======================
  # Desktop Environment
  # ======================
  services.desktopManager.plasma6.enable = true;

  # ======================
  # Portály pro sandboxované aplikace
  # ======================
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  # ======================
  # Hardware a napájení
  # ======================
  hardware.graphics.enable = true;

  services.power-profiles-daemon.enable = true;

  # ======================
  # Desktop konfigurace
  # ======================
  programs.dconf.enable = true;

  # ======================
  # Systémové balíčky KDE
  # ======================
  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.kio-extras
    kdePackages.kio-fuse
  ];
}
