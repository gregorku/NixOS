{ pkgs, ... }:

{
  # ==================================================
  # INCUS
  # ==================================================
  #
  # Incus slouží pro provoz systémových kontejnerů
  # a případně virtuálních strojů.
  #
  # Storage:
  #
  #   Incus storage pool:  default
  #   ZFS backend:         zfs-image/incus
  #
  # Síť:
  #
  #   br0
  #     systémový bridge spravovaný NixOS
  #     a systemd-networkd
  #
  #   incusbr0
  #     privátní NAT síť spravovaná Incus
  #

  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };


  # ==================================================
  # INCUS ADMIN
  # ==================================================
  #
  # Uživatel gregor může spravovat Incus bez sudo.
  #
  # Po prvním přidání uživatele do skupiny je nutné
  # nové přihlášení, aby se členství aktivovalo.

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
  # INCUS INITIAL SETUP
  # ==================================================
  #
  # Inicializační služba:
  #
  #   1. vytvoří NAT síť incusbr0, pokud neexistuje;
  #
  #   2. vytvoří Incus storage pool default nad:
  #
  #        zfs-image/incus
  #
  #      pokud ještě neexistuje;
  #
  #   3. vytvoří root disk v profilu default,
  #      pokud ještě neexistuje;
  #
  #   4. vytvoří síťové zařízení eth0 v profilu
  #      default, pokud ještě neexistuje.
  #
  # Systémový bridge br0 Incus nevytváří ani
  # nespravuje. Kontejnery se na něj připojují přes:
  #
  #   nictype = bridged
  #   parent   = br0
  #
  # Služba je idempotentní:
  # již existující objekty znovu nevytváří.

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
      # NAT NETWORK – incusbr0
      # ==================================================
      #
      # Privátní Incus síť:
      #
      #   subnet:   10.10.10.0/24
      #   gateway:  10.10.10.1
      #   IPv4 NAT: ano
      #   IPv6:     vypnuto
      #
      # Síť není nastavena jako výchozí síť profilu
      # default. Je připravena pro kontejnery, které
      # mají být oddělené od fyzické LAN.

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
      # Dataset není nutné vytvářet ručně.
      # Při čisté inicializaci jej vytvoří Incus.

      if ! "$INCUS" storage show default >/dev/null 2>&1; then

        echo "Creating Incus ZFS storage pool default..."

        "$INCUS" storage create default zfs \
          source=zfs-image/incus

      else

        echo "Storage pool default already exists."

      fi


      # ==================================================
      # DEFAULT PROFILE – ROOT DISK
      # ==================================================
      #
      # Root filesystem kontejnerů používajících profil
      # default bude uložen na storage poolu default:
      #
      #   default
      #     -> zfs-image/incus

      if "$INCUS" profile device show default \
        | grep -q '^root:'; then

        echo "Root device already exists in default profile."

      else

        echo "Adding root device to default profile..."

        "$INCUS" profile device add \
          default \
          root \
          disk \
          path=/ \
          pool=default

      fi


      # ==================================================
      # DEFAULT PROFILE – LAN NETWORK
      # ==================================================
      #
      # Výchozí kontejnery budou připojené přímo
      # do fyzické LAN přes systémový bridge:
      #
      #   br0
      #
      # br0 je unmanaged z pohledu Incus.
      #
      # Proto se nepoužívá:
      #
      #   network=br0
      #
      # ale:
      #
      #   nictype=bridged
      #   parent=br0

      if "$INCUS" profile device show default \
        | grep -q '^eth0:'; then

        echo "Network device eth0 already exists in default profile."

      else

        echo "Adding eth0 to default profile..."

        "$INCUS" profile device add \
          default \
          eth0 \
          nic \
          nictype=bridged \
          parent=br0

      fi


      echo "========================================"
      echo " Incus init finished"
      echo "========================================"
    '';
  };
}