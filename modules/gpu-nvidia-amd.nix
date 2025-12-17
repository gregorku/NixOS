{ config, lib, pkgs, ... }:

{
  # Primární GPU = AMD iGPU
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # NVIDIA zapnutá jen na vyžádání
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
    };

    # Power management – klíčové pro notebook
    powerManagement = {
      enable = true;
      finegrained = true;
    };

    # Používej proprietární ovladač (správně pro RTX 3070)
    open = false;
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    libva-utils
  ];
}
