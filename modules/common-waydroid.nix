{ config, pkgs, lib, ... }:

{
  virtualisation.waydroid.enable = true;

  # Waydroid potřebuje LXC + binder
  boot.kernelModules = [ "binder_linux" "ashmem_linux" ];

  # některé systémy už ashmem nemají → fallback
  boot.extraModulePackages = with config.boot.kernelPackages; [
    binder_linux
  ];

  # network (Waydroid container)
  networking.firewall.enable = true;

  # doporučeno pro video / GPU
  hardware.opengl.enable = true;

  # pokud používáš PipeWire (pravděpodobně ano)
  services.pipewire.enable = true;

  # user musí být ve skupině
  users.users.gregor = {
    extraGroups = [ "waydroid" "video" "render" ];
  };

  # adb pro debug
  environment.systemPackages = with pkgs; [
    waydroid
    android-tools
  ];
}