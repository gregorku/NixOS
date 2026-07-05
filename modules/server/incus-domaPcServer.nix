{ config, pkgs, ... }:

{
  # ─────────────────────────────────────
  # 📦 INCUS
  # ─────────────────────────────────────

  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

  # ─────────────────────────────────────
  # 👤 INCUS ADMIN
  # ─────────────────────────────────────

  users.groups.incus-admin = { };

  users.users.gregor.extraGroups = [
    "incus-admin"
  ];

  # ─────────────────────────────────────
  # 📦 BALÍČKY
  # ─────────────────────────────────────

  environment.systemPackages = with pkgs; [
    incus
  ];

  # ─────────────────────────────────────
  # ⚙️ INCUS INITIAL SETUP
  # ─────────────────────────────────────
  #
  # Služba:
  #
  #   1. vytvoří NAT síť incusbr0
  #   2. přidá systémový bridge br0 do Incus
  #   3. připojí existující ZFS dataset:
  #
  #        zfs-NVME-4TB/incus
  #
  #      jako Incus storage pool:
  #
  #        default
  #
  #   4. nastaví default profil na síť br0
  #
  # Jednotlivé kroky jsou idempotentní:
  # existující síť nebo storage pool se znovu nevytváří.

  systemd.services.incus-init = {
    description = "Incus initial setup for domaPcServer";

    after = [
      "incus.service"
      "zfs-import-zfs-NVME-4TB.service"
    ];

    requires = [
      "incus.service"
    ];

    wantedBy = [
      "multi-user.target"
    ];

    serviceConfig = {
      Type = "oneshot";

      RemainAfterExit = true;
    };

    script = ''
      set -e

      INCUS=${pkgs.incus}/bin/incus

      echo "========================================"
      echo " Incus init – domaPcServer"
      echo "========================================"


      # ─────────────────────────────────────
      # NAT NETWORK – incusbr0
      # ─────────────────────────────────────

      if ! $INCUS network show incusbr0 >/dev/null 2>&1; then

        echo "Creating Incus NAT network incusbr0..."

        $INCUS network create incusbr0 \
          ipv4.address=10.10.10.1/24 \
          ipv4.nat=true \
          ipv6.address=none

      else

        echo "Network incusbr0 already exists."

      fi


      # ─────────────────────────────────────
      # LAN BRIDGE – br0
      # ─────────────────────────────────────
      #
      # br0 je systémový bridge vytvořený
      # modulem server-br0.nix.
      #
      # Incus jej používá jako physical network.

      if ! $INCUS network show br0 >/dev/null 2>&1; then

        echo "Creating Incus physical network br0..."

        $INCUS network create br0 \
          --type=physical \
          parent=br0 \
          ipv4.address=none \
          ipv6.address=none

      else

        echo "Network br0 already exists."

      fi


      # ─────────────────────────────────────
      # STORAGE – ZFS
      # ─────────────────────────────────────
      #
      # ZFS pool:
      #
      #   zfs-image
      #
      # bude používat Incus pro běžící
      # kontejnery a virtuální stroje.
      #
      # Incus storage pool:
      #
      #   default
      #
      # ZFS dataset:
      #
      #   zfs-image/incus

      if ! $INCUS storage show default >/dev/null 2>&1; then

        echo "Creating Incus ZFS storage pool default..."

        $INCUS storage create default zfs \
          source=zfs-image/incus

      else

        echo "Storage pool default already exists."

      fi

      # ─────────────────────────────────────
      # DEFAULT PROFILE → br0
      # ─────────────────────────────────────

      echo "Setting default profile network to br0..."

      $INCUS profile device set \
        default \
        eth0 \
        network=br0 \
        || true


      echo "========================================"
      echo " Incus init finished"
      echo "========================================"
    '';
  };
}