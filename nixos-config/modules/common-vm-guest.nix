{ config, pkgs, ... }:

{
  ##################################################
  # Guest tools – QEMU / KVM (pouze VM)
  ##################################################

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
