{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];
}