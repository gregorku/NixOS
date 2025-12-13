{ config, pkgs, ... }:

{
  # 🔑 ZÁKLAD GRAFIKY
  services.xserver.enable = true;

  # 🔑 DISPLAY MANAGER + KDE
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # 🔊 AUDIO (správně)
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # 🌐 SÍŤ
  networking.networkmanager.enable = true;
}
