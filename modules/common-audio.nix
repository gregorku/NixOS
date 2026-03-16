{ config, pkgs, ... }:

{
  # ======================
  # Firmware pro audio zařízení
  # ======================
  hardware.enableRedistributableFirmware = true;

  # ======================
  # Vypnout starý PulseAudio
  # ======================
  services.pulseaudio.enable = false;

  # ======================
  # Moderní audio stack: PipeWire
  # ======================
  services.pipewire = {
    enable = true;            # spustí PipeWire
    audio.enable = true;      # ALSA + Pulse kompatibilita
    pulse.enable = true;      # emulace PulseAudio
    alsa.enable = true;       # ALSA zařízení
    alsa.support32Bit = true; # 32-bit aplikace
    jack.enable = true;       # JACK pro profi audio
  };

  # ======================
  # Realtime audio permissions
  # ======================
  security.rtkit.enable = true;

  # ======================
  # Doporučený kernel modul pro Intel/AMD audio
  # ======================
  boot.kernelModules = [ "snd_hda_intel" ];
}