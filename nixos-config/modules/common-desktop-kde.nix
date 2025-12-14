{ config, pkgs, ... }:

{
  # 🔑 ZÁKLAD GRAFIKY (SDDM + fallback X11)
  services.xserver.enable = true;

  # 🔑 DISPLAY MANAGER + KDE Plasma 6
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # 🔊 AUDIO – PipeWire (25.05 správně)
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # 🖥️ XDG Portals (Flatpak, screencast, dialogs)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];

  # 🌐 NETWORK
  networking.networkmanager.enable = true;
}
