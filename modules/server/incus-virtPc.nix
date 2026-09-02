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

after = [
  "incus.service"
  "zfs-import.target"
];

requires = [
  "incus.service"
  "zfs-import.target"
];

wantedBy = [ "multi-user.target" ];

serviceConfig.Type = "oneshot";

script = ''
  set -e
  INCUS=${pkgs.incus}/bin/incus

  echo "=== Incus init ==="

  # ----------------------
  # NAT network (incusbr0)
  # ----------------------
  if ! $INCUS network show incusbr0 >/dev/null 2>&1; then
    echo "Creating incusbr0..."
    $INCUS network create incusbr0 \
      ipv4.address=10.10.10.1/24 \
      ipv4.nat=true \
      ipv6.address=none
  else
    echo "incusbr0 already exists."
  fi

  # ----------------------
  # LAN bridge (br0)
  #
  # br0 is managed by NixOS/systemd-networkd.
  # Incus only uses it as the parent bridge for containers.
  # ----------------------

  # ----------------------
  # ZFS storage
  # ----------------------
  if ! $INCUS storage show default >/dev/null 2>&1; then
    echo "Creating ZFS storage..."
    $INCUS storage create default zfs \
      source=zfs-NVME-4TB/incus
  else
    echo "default storage already exists."
  fi

  # ----------------------
  # Default profile → existing Linux br0
  # ----------------------
  echo "Setting default profile to br0..."

  if ! $INCUS profile show default | grep -q 'eth0:'; then
    $INCUS profile device add default eth0 nic \
      nictype=bridged \
      parent=br0
  else
    echo "eth0 already exists in default profile."
  fi

  echo "=== Incus init complete ==="
'';

};
}
