{ config, pkgs, ... }:

{
  # ----------------------
  # Incus
  # ----------------------
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

  # ----------------------
  # Přístup (bez roota)
  # ----------------------
  users.groups.incus-admin = {};

  users.users.gregor.extraGroups = [ "incus-admin" ];

  # ----------------------
  # CLI nástroje
  # ----------------------
  environment.systemPackages = with pkgs; [
    incus
  ];

  # ----------------------
  # Inicializace Incus (network + storage)
  # ----------------------
  systemd.services.incus-init = {
    description = "Incus initial setup (network + storage)";
    after = [ "incus.service" ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      set -e

      echo "Checking Incus network..."
      if ! incus network list | grep -q incusbr0; then
        echo "Creating incusbr0..."
        incus network create incusbr0 \
          ipv4.address=10.10.10.1/24 \
          ipv4.nat=true \
          ipv6.address=none
      fi

      echo "Checking Incus storage..."
      if ! incus storage list | grep -q default; then
        echo "Creating ZFS storage pool..."
        incus storage create default zfs source=zfs-pool-incus/incus
      fi
    '';

    serviceConfig = {
      Type = "oneshot";
    };
  };
}