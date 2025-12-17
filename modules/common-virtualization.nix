{ config, pkgs, ... }:

{
  # ----------------------
  # Virtualization (KVM / libvirt)
  # ----------------------

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
    };
  };

  # Virt-manager GUI
  programs.virt-manager.enable = true;

  # User access (no sudo needed)
  users.users.gregor.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  # Polkit: allow libvirt management without password
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("libvirtd") &&
        action.id.startsWith("org.libvirt")
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}
