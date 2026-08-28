{ config, pkgs, ... }:

{
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

  users.groups.incus-admin = {};
  users.users.gregor.extraGroups = [ "incus-admin" ];

  environment.systemPackages = with pkgs; [
    incus
  ];

  systemd.services.incus-init = {
    description = "Incus initial setup (network + storage)";
    after = [ "incus.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = ''
      set -e
      INCUS=${pkgs.incus}/bin/incus

      echo "=== Incus init ==="

      # ----------------------
      # NAT network (incusbr0)
      # ----------------------
      if ! $INCUS network list | grep -q incusbr0; then
        echo "Creating incusbr0..."
        $INCUS network create incusbr0 \
          ipv4.address=10.10.10.1/24 \
          ipv4.nat=true \
          ipv6.address=none
      fi

      # ----------------------
      # LAN bridge (br0) — existující systémový bridge
      # ----------------------
      if ! $INCUS network list | grep -q '^| br0 '; then
        echo "Creating br0 network..."
        $INCUS network create br0 --type=physical \
          parent=br0 \
          ipv4.address=none \
          ipv6.address=none
      fi

      # ----------------------
      # Storage (existující ZFS)
      # ----------------------
      if ! $INCUS storage list | grep -q '^| default '; then
        echo "Creating ZFS storage..."
        $INCUS storage create default zfs source=zfs-NVME-4TB/incus
      fi

      # ----------------------
      # Default profile → br0
      # ----------------------
      echo "Setting default profile to br0..."
      $INCUS profile device set default eth0 network=br0 || true
    '';
  };
}
