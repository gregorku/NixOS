{ config, lib, pkgs, ... }:

{
  ##################################################
  # VirtIO GPU + Wayland (VM)
  ##################################################

  services.xserver.videoDrivers = [ "virtio" ];

  # Wayland je default pro Plasma 6,
  # ale explicitně ho povolíme
  services.xserver.enable = true;

  # Mesa + virgl (OpenGL akcelerace)
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    mesa
    mesa-demos
  ];
}
