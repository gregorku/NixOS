{ config, pkgs, lib, ... }:

{
  # ----------------------
  # 🖥️ Display manager
  # ----------------------
  services.displayManager.sddm = {
    enable = true;

    # Wayland login screen
    wayland.enable = true;
  };

  # ----------------------
  # 🖥️ KDE Plasma 6
  # ----------------------
  services.desktopManager.plasma6.enable = true;

  # ----------------------
  # 🔗 XDG Portal
  # ----------------------
  xdg.portal = {
    enable = true;

    # Doporučeno pro Wayland
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  # ----------------------
  # 🎮 OpenGL / Vulkan
  # ----------------------
  hardware.graphics.enable = true;

  # ----------------------
  # ⚙️ GNOME nastavení pro GTK aplikace
  # ----------------------
  programs.dconf.enable = true;

  # ----------------------
  # 📦 KDE balíčky
  # ----------------------
  environment.systemPackages = with pkgs; [

    # KDE Connect
    kdePackages.kdeconnect-kde
    # KDE Správa hesel
    kdePackages.kwalletmanager

    # Samba, MTP, archivy...
    kdePackages.kio-extras
    kdePackages.kio-fuse

    # 🎨 Theme
    catppuccin-kde
    papirus-icon-theme
  ];

  # ----------------------
  # 🔐 Sudo
  # ----------------------
  security.sudo.extraRules = [
  {
  users = [ "gregor" ];
    commands = [
      {
        command = "${pkgs.openconnect}/bin/openconnect";
        options = [ "NOPASSWD" ];
      }
    ];
  }
  ];
}