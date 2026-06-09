{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      rocm-opencl-runtime
    ];
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];
}