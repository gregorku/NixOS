{ config, pkgs, lib, ... }:

{
  virtualisation.waydroid.enable = true;

  boot.kernelModules = [ "binder_linux" ];

  hardware.graphics.enable = true;

  services.pipewire.enable = true;

  users.users.gregor.extraGroups = [
    "waydroid"
    "video"
    "render"
  ];

  environment.systemPackages = with pkgs; [
    waydroid
    android-tools
  ];
}