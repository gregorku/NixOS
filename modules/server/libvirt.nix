{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      swtpm.enable = true;
      ovmf.enable = true;
      ovmf.packages = [ pkgs.OVMFFull ];
    };
  };

  programs.virt-manager.enable = true;

  users.users.gregor.extraGroups = [
    "libvirtd"
  ];
}
