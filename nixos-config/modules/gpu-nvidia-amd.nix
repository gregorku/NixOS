{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaPersistenced = true;
    open = false;
  };

  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];
}
