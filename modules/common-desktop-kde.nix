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
    # KDE utils
    kdePackages.kdeconnect-kde
    kdePackages.kio-extras
    kdePackages.kio-fuse

    # 🎨 THEME (KLÍČOVÉ)
    catppuccin-kde
    papirus-icon-theme

    # 🔥 FIX GTK aplikace v KDE (virt-manager, gimp ikony)
    kdePackages.kde-gtk-config
    gsettings-desktop-schemas
  ];
}
