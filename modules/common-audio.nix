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
  };

  # ======================
  # Realtime audio permissions
  # ======================
  security.rtkit.enable = true;

  # ======================
  # Kernel moduly (HDA fallback)
  # ======================
  boot.kernelModules = [
    "snd_hda_intel"
  ];

  # ======================
  # AMD fix (vypnutí ACP / DMIC)
  # ======================
  boot.kernelParams = [
    "snd_hda_intel.dmic_detect=0"
  ];
}