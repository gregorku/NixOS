{ config, pkgs, ... }:

{
  # ==================================================
  # IMPORTY MODULŮ
  # ==================================================

  imports = [
    # ────────────────────────────────────────────────
    # Hardware tohoto serveru
    # ────────────────────────────────────────────────

    ./hardware-configuration.nix


    # ────────────────────────────────────────────────
    # Secrets
    # ────────────────────────────────────────────────

    # /etc/nixos/secrets/ssh


    # ────────────────────────────────────────────────
    # Common – sdílené moduly
    # ────────────────────────────────────────────────

    ../../modules/common-security.nix
    ../../modules/common-server-swap.nix

    # ../../modules/common-snapshots.nix


    # ────────────────────────────────────────────────
    # Server – základní moduly
    # ────────────────────────────────────────────────

    ../../modules/server/server-apps.nix
    ../../modules/server/server-base.nix
    ../../modules/server/cockpit.nix

    # Incus zapnout po dokončení konfigurace storage.
    #
    ../../modules/server/incus-domaPcServer.nix

    # Libvirt zatím není potřeba.
    #
    # ../../modules/server/libvirt.nix


    # Samostatný ZFS modul zatím nepoužíváme.
    # Import poolů je definován přímo v tomto souboru.
    #
    # ../../modules/server/zfs.nix

    # Monitoring server Pc.
    #
    ../../modules/server/monitoringPc.nix

    # Automatické aktualizace zapnout až po dokončení
    # a otestování základní konfigurace serveru.
    #
    # ../../auto-upgrade.nix


    # ────────────────────────────────────────────────
    # Síť
    # ────────────────────────────────────────────────

    # Bridge br0.
    ../../modules/server/server-br0.nix

    # Vlastní nftables firewall a DNAT pravidla.
    ../../modules/server/firewall/firewall-domaServerPc.nix
    # Unlock port 2223
    ../../modules/security/initrd-unlock.nix
    ];
    # ─────────────────────────────────────
    # 🌐 Initrd network
    # ─────────────────────────────────────
    #
    # Síť používaná pouze během initrd pro
    # vzdálené odemykání LUKS přes SSH.
    # V initrd ještě neexistuje bridge br0.
    # Proto se statická IP adresa nastavuje
    # přímo na fyzické rozhraní enp7s0.
    #
    # Po odemčení LUKS a přechodu do běžného
    # systému tato konfigurace zanikne.
    #
    # Následně běžná konfigurace NixOS vytvoří
    # bridge br0, připojí do něj enp7s0 a síť
    # bude pokračovat podle konfigurace br0.
    #

    boot.initrd.systemd.network.enable = true;

    boot.initrd.systemd.network.networks."10-initrd-enp7s0" = {
      matchConfig.Name = "enp7s0";

      address = [
        "192.168.100.200/24"
      ];

      routes = [
        {
          Gateway = "192.168.100.1";
        }
      ];

      networkConfig = {
        DHCP = "no";
      };
    };

    # ─────────────────────────────────────
    # 🌐 Síťový ovladač v initrd
    # ─────────────────────────────────────
    #
    # Síťová karta enp7s0 používá ovladač r8169.
    #
    # Ovladač musí být dostupný už v initrd,
    # aby bylo možné inicializovat síť před
    # odemčením šifrovaného root filesystemu.
    #

    boot.initrd.availableKernelModules = [
      "r8169"
    ];

    # ────────────────────────────────────────────────
    # systemd-nspawn kontejnery
    # ────────────────────────────────────────────────
    #
    # Aktuálně nepoužívané.
    # Ponecháno jako vzor pro případné budoucí použití.


  # ==================================================
  # ZÁKLADNÍ NASTAVENÍ SYSTÉMU
  # ==================================================

  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "cs_CZ.UTF-8";

  console.keyMap = "cz";


  # ────────────────────────────────────────────────
  # Nix – flakes
  # ────────────────────────────────────────────────

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  # ==================================================
  # BOOTLOADER
  # ==================================================
  #
  # Server bootuje přes UEFI a systemd-boot.
  #
  # EFI System Partition je připojená přímo:
  #
  #   /boot
  #
  # Obsahuje:
  #
  #   systemd-boot
  #   NixOS boot entries
  #   kernel
  #   initrd
  #   LUKS keyfile

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi = {
    canTouchEfiVariables = true;

    efiSysMountPoint = "/boot";
  };


  # ==================================================
  # LUKS – ŠIFROVANÝ SYSTÉMOVÝ DISK
  # ==================================================
  #
  # Systémový disk:
  #
  #   /dev/nvme0n1
  #
  # EFI:
  #
  #   /dev/nvme0n1p1
  #
  # LUKS:
  #
  #   /dev/nvme0n1p2
  #
  # LUKS UUID:
  #
  #   5a775301-f99e-4b41-9332-dbbfc8947db6
  #
  # Odemčení při bootu probíhá pomocí keyfile:
  #
  #   /boot/crypto_keyfile.bin
  #
  # NixOS vloží keyfile do initrd jako:
  #
  #   /crypto_keyfile.bin
  #
  # Původní LUKS heslo zůstává jako záložní možnost
  # pro ruční odemčení systémového disku.

  boot.initrd.luks.devices."cryptroot" = {
    device =
      "/dev/disk/by-uuid/5a775301-f99e-4b41-9332-dbbfc8947db6";

    #keyFile = "/crypto_keyfile.bin";

    # Systémový disk nepoužívá LVM.
    #
    # Proto zde není:
    #
    # preLVM = true;
  };


  # Keyfile je při sestavení initrd načten z EFI oddílu.

  #boot.initrd.secrets = {
  #  "/crypto_keyfile.bin" =
  #    "/boot/crypto_keyfile.bin";
  #};


  # ==================================================
  # FILESYSTEMY A DATOVÉ DISKY
  # ==================================================


  # ────────────────────────────────────────────────
  # VIDEO DISK – XFS
  # ────────────────────────────────────────────────
  #
  # Samostatný datový disk pro video.
  #
  # UUID:
  #
  #   203f383c-f1b8-4a8e-8687-abeb29bd1721
  #
  # Mountpoint:
  #
  #   /hdd-disk/video
  #
  # nofail:
  #
  #   Server nabootuje i v případě, že disk nebude
  #   dostupný.
  #
  # Stav lze ověřit:
  #
  #   lsblk -f
  #
  #   findmnt /hdd-disk/video

  fileSystems."/hdd-disk/video" = {
    device =
      "/dev/disk/by-uuid/203f383c-f1b8-4a8e-8687-abeb29bd1721";

    fsType = "xfs";

    options = [
      "noatime"
      "nofail"
    ];
  };


  # ==================================================
  # ZFS
  # ==================================================
  #
  # Server používá tři samostatné ZFS pooly:
  #
  #
  # 1. datapool
  #
  #    Mountpoint:
  #
  #      /zfs-datapool
  #
  #    Obsahuje například:
  #
  #      datapool/ha-data
  #
  #
  # 2. zfs-NVME-4TB
  #
  #    Mountpoint:
  #
  #      /zfs-incus
  #
  #    Obsahuje původní Incus datasety a další data.
  #
  #
  # 3. zfs-image
  #
  #    Mountpoint:
  #
  #      /zfs-image
  #
  #    Samostatný NVMe pool určený pro běžící
  #    Incus kontejnery a virtuální stroje.
  #
  #    Incus bude používat:
  #
  #      zfs-image/incus
  #
  #    jako backend pro Incus storage pool:
  #
  #      default


  boot.supportedFilesystems = [
    "zfs"
  ];


  # Explicitní import datových ZFS poolů při bootu.

  boot.zfs.extraPools = [
    "datapool"
    "zfs-NVME-4TB"
    "zfs-image"
  ];


  # Root filesystem není na ZFS.
  #
  # Systémový root je:
  #
  #   LUKS
  #     └── Btrfs
  #
  # Proto není potřeba vynucovat import root ZFS poolu.

  boot.zfs.forceImportRoot = false;


  # Automatický scrub je zatím vypnutý.
  #
  # Později lze přidat vlastní plánovaný scrub
  # pro jednotlivé pooly.

  services.zfs.autoScrub.enable = false;


  # Automatické ZFS snapshoty jsou zatím vypnuté.
  #
  # Snapshot strategii nastavíme samostatně podle
  # typu dat v jednotlivých poolech.

  services.zfs.autoSnapshot.enable = false;


  # ==================================================
  # SÍŤ
  # ==================================================

  networking = {
    hostName = "domaPcServer";


    # NetworkManager je vypnutý.
    #
    # Síťovou konfiguraci a bridge br0 spravuje
    # systemd-networkd přes server-br0.nix.

    networkmanager.enable = false;


    # Unikátní 8znakový hostId serveru.
    #
    # Je důležitý zejména pro bezpečné rozlišení
    # hostitele při práci se ZFS pooly.

    hostId = "f474d573";


    # DNS resolver spravuje systemd-resolved.

    useHostResolvConf = false;
  };


  # ────────────────────────────────────────────────
  # DNS resolver
  # ────────────────────────────────────────────────

  services.resolved.enable = true;


  # ────────────────────────────────────────────────
  # LAN bridge br0
  # ────────────────────────────────────────────────
  #
  # Fyzické rozhraní:
  #
  #   enp7s0
  #
  # je členem bridge:
  #
  #   br0
  #
  # IP adresa serveru je přidělena bridge br0,
  # nikoli fyzickému rozhraní enp7s0.
  #
  # Bridge bude později možné používat také
  # pro Incus kontejnery připojené přímo do LAN.

  server.br0 = {
    enable = true;

    interface = "enp7s0";
  };


  # ==================================================
  # SSH
  # ==================================================

  services.openssh = {
    enable = true;

    settings = {
      # Root se může přes SSH přihlásit pouze pomocí
      # SSH klíče.
      #
      # Přihlášení roota heslem je zakázané.

      PermitRootLogin = "prohibit-password";


      # Dočasně povolené přihlášení uživatele heslem.
      #
      # Po ověření SSH klíče uživatele gregor změnit:
      #
      # PasswordAuthentication = false;

      PasswordAuthentication = true;
    };
  };


  # ==================================================
  # MONITORING DISKŮ
  # ==================================================
  #
  # smartd automaticky detekuje podporované disky
  # a sleduje jejich SMART stav.

  services.smartd = {
    enable = true;

    autodetect = true;

    # E-mailové notifikace zatím nejsou nastavené.

    notifications.mail.enable = false;
  };


  # ==================================================
  # SSD / NVMe TRIM
  # ==================================================
  #
  # Pravidelný TRIM pro SSD a NVMe zařízení.

  services.fstrim.enable = true;


  # ==================================================
  # OCHRANA PAMĚTI – EARLYOOM
  # ==================================================
  #
  # earlyoom ukončí procesy při kritickém nedostatku
  # RAM nebo swap prostoru dříve, než server přestane
  # reagovat.
  #
  # freeMemThreshold:
  #
  #   zásah při poklesu volné RAM pod 5 %
  #
  # freeSwapThreshold:
  #
  #   zásah při poklesu volného swapu pod 10 %

  services.earlyoom = {
    enable = true;

    freeMemThreshold = 5;

    freeSwapThreshold = 10;
  };


  # ==================================================
  # UŽIVATELÉ
  # ==================================================

  users.users.gregor = {
    isNormalUser = true;


    # Heslo není deklarováno v konfiguraci.
    #
    # Nastavuje se ručně:
    #
    #   sudo passwd gregor


    # wheel:
    #
    #   umožňuje používat sudo.

    extraGroups = [
      "wheel"
    ];
  };


  # ==================================================
  # NIXOS STATE VERSION
  # ==================================================
  #
  # Tuto hodnotu neměnit při běžném upgrade NixOS.
  #
  # Určuje kompatibilní výchozí chování stavových
  # služeb od první instalace tohoto systému.

  system.stateVersion = "26.05";
}
