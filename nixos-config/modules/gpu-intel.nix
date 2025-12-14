{ config, pkgs, ... }:

{
  # Modern Intel iGPU setup (X11 + Wayland)
  hardware.graphics.enable = true;

  # VAAPI / VDPAU
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
    vaapiVdpau
    libvdpau-va-gl
  ];

  # Diagnostic / testing tools
  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];
}
