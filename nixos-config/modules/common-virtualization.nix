{ config, pkgs, ... }:

{
  # ----------------------
  # Virtualizace (KVM / libvirt)
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

  # Uživatel gregor může spravovat VM bez hesla
  users.users.gregor.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  # Polkit pravidlo – žádné heslo pro virt-manager
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

  # Doporučeno pro síťování VM
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  # Autostart služby
  systemd.services.libvirtd.wantedBy = [ "multi-user.target" ];
}
