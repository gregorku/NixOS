{ config, pkgs, lib, ... }:

{
  # Waydroid
  virtualisation.waydroid.enable = true;

  # Binder (nutné pro Android container)
  boot.kernelModules = [ "binder_linux" ];

  # Grafika (nová volba místo opengl)
  hardware.graphics.enable = true;

  # Audio (pokud používáš PipeWire)
  services.pipewire.enable = true;

  # ARM translation (klíčová věc pro APK)
  environment.sessionVariables = {
    WAYDROID_ENABLE_ARM_TRANSLATION = "1";
  };

  # Uživatel
  users.users.gregor.extraGroups = [
    "waydroid"
    "video"
    "render"
  ];

  # Balíčky
  environment.systemPackages = with pkgs; [
    waydroid
    android-tools
  ];
}