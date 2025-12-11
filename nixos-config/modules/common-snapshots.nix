{ config, pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    version = 2;
    copyKernels = true;
    configurationLimit = 10;
  };

  system.autoUpgrade.enable = false;
}
