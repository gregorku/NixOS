{ config, pkgs, ... }:

{
  hardware.opengl.enable = true;

  services.xserver.videoDrivers = [ "virtio" ];

  environment.systemPackages = with pkgs; [
    mesa
    mesa-demos
    vulkan-tools
    virtiofsd
  ];
}
