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

  # ❌ pryč:
  # boot.kernelModules = [ "snd_hda_intel" ];

  # ✅ správné chování driveru
  boot.kernelParams = [ "snd_intel_dspcfg.dsp_driver=3" ];
}