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
    enable = true;            # PipeWire daemon
    audio.enable = true;      # ALSA + Pulse kompatibilita
    pulse.enable = true;      # PulseAudio emulace
    alsa.enable = true;       # ALSA zařízení
    alsa.support32Bit = true; # 32-bit aplikace
    jack.enable = true;       # JACK (pro audio tools)
  };

  # ======================
  # Realtime audio permissions
  # ======================
  security.rtkit.enable = true;

  # ======================
  # Kernel moduly pro audio (AMD + fallback)
  # ======================
  boot.kernelModules = [
    "snd_hda_intel"   # fallback + HDMI + Intel
    "snd_acp3x"       # AMD ACP
    "snd_pci_acp3x"   # AMD ACP PCI
  ];

  # ======================
  # Kernel parametry
  # ======================
  # ⚠️ Intel parametr jsme odstranili → byl problém pro AMD
  # boot.kernelParams = [ "snd_intel_dspcfg.dsp_driver=3" ];
}