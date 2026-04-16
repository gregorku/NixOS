{ config, pkgs, ... }:

{
  # ======================
  # Firmware pro audio zařízení
  # ======================
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  # ======================
  # Vypnout starý PulseAudio
  # ======================
  services.pulseaudio.enable = false;

  # ======================
  # Moderní audio stack: PipeWire
  # ======================
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;

    # 🔥 důležité pro unstable / KDE 6
    wireplumber.enable = true;
  };

  # ======================
  # Realtime audio permissions
  # ======================
  security.rtkit.enable = true;
}