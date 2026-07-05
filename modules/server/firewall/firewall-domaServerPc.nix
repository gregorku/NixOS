{ pkgs, ... }:

{
  # ==================================================
  # INCUS
  # ==================================================
  #
  # Incus slouží pro provoz systémových kontejnerů
  # a případně virtuálních strojů.
  #
  # Datový backend:
  #
  #   ZFS pool:          zfs-image
  #   ZFS dataset:       zfs-image/incus
  #   Incus storage:     default
  #
  # Síťové možnosti:
  #
  #   br0        přímé připojení kontejneru do LAN
  #   incusbr0   privátní NAT síť
  #

  virtualisation.incus = {
    enable = true;

    ui.enable = true;
  };


  # ==================================================
  # OPRÁVNĚNÍ UŽIVATELE
  # ==================================================
  #
  # Člen skupiny incus-admin může spravovat Incus
  # bez použití sudo.
  #
  # Po prvním přidání do skupiny je nutné nové
  # přihlášení uživatele.

  users.groups.incus-admin = { };

  users.users.gregor.extraGroups = [
    "incus-admin"
  ];


  # ==================================================
  # BALÍČKY
  # ==================================================

  environment.systemPackages = with pkgs; [
    incus
  ];


  # ==================================================
  # POČÁTEČNÍ KONFIGURACE INCUS
  # ==================================================
  #
  # Služba je navržena jako opakovatelná.
  #
  # Při spuštění:
  #
  #   1. vytvoří privátní NAT síť incusbr0,
  #      pokud ještě neexistuje;
  #
  #   2. zaregistruje systémový bridge br0
  #      jako Incus physical network,
  #      pokud ještě neexistuje;
  #
  #   3. vytvoří storage pool default nad:
  #
  #        zfs-image/incus
  #
  #      pokud storage pool ještě neexistuje;
  #
  #   4. nastaví zařízení eth0 v profilu default
  #      na systémový bridge br0.
  #
  # Dataset zfs-image/incus nevytváříme ručně.
  # Při prvním vytvoření storage jej připraví Incus.

  systemd.services.incus-init = {
    description = "Incus initial setup for domaPcServer";

    after = [
      "incus.service"
      "zfs-import-zfs-image.service"
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
      set -euo pipefail

      INCUS=${pkgs.incus}/bin/incus


      echo "========================================"
      echo " Incus init – domaPcServer"
      echo "========================================"


      # ==================================================
      # NAT SÍŤ – incusbr0
      # ==================================================

      if ! "$INCUS" network show incusbr0 >/dev/null 2>&1; then

        echo "Creating Incus NAT network incusbr0..."

        "$INCUS" network create incusbr0 \
          ipv4.address=10.10.10.1/24 \
          ipv4.nat=true \
          ipv6.address=none

      else

        echo "Network incusbr0 already exists."

      fi


      # ==================================================
      # LAN BRIDGE – br0
      # ==================================================
      #
      # br0 je systémový bridge vytvořený modulem:
      #
      #   server-br0.nix
      #
      # Incus jej pouze registruje jako physical network.
      # Samotný bridge nevytváří ani nespravuje.

      if ! "$INCUS" network show br0 >/dev/null 2>&1; then

        echo "Creating Incus physical network br0..."

        "$INCUS" network create br0 \
          --type=physical \
          parent=br0

      else

        echo "Network br0 already exists."

      fi


      # ==================================================
      # STORAGE – ZFS
      # ==================================================
      #
      # Incus storage pool:
      #
      #   default
      #
      # ZFS backend:
      #
      #   zfs-image/incus
      #
      # Při prvním spuštění Incus vytvoří dataset
      # a následně vlastní podřízenou strukturu.

      if ! "$INCUS" storage show default >/dev/null 2>&1; then

        echo "Creating Incus ZFS storage pool default..."

        "$INCUS" storage create default zfs \
          source=zfs-image/incus

      else

        echo "Storage pool default already exists."

      fi


      # ==================================================
      # DEFAULT PROFILE – NETWORK
      # ==================================================
      #
      # Výchozí kontejnery budou připojené přímo
      # do LAN přes systémový bridge br0.

      if "$INCUS" profile device show default \
        | grep -q '^eth0:'; then

        echo "Updating eth0 in default profile..."

        "$INCUS" profile device set \
          default \
          eth0 \
          network=br0

      else

        echo "Adding eth0 to default profile..."

        "$INCUS" profile device add \
          default \
          eth0 \
          nic \
          network=br0

      fi


      # ==================================================
      # DEFAULT PROFILE – ROOT DISK
      # ==================================================
      #
      # Ověříme také root disk zařízení.
      #
      # Čistá konfigurace nemusí mít root zařízení
      # navázané na storage pool default.

      if "$INCUS" profile device show default \
        | grep -q '^root:'; then

        echo "Root disk already exists in default profile."

      else

        echo "Adding root disk to default profile..."

        "$INCUS" profile device add \
          default \
          root \
          disk \
          path=/ \
          pool=default

      fi


      echo "========================================"
      echo " Incus init finished"
      echo "========================================"
    '';
  };
}