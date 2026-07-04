{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # /etc/nixos/secrets/ssh

    ##################################################
    # Common – sdílené moduly
    ##################################################
    ../../modules/common-security.nix
    ../../modules/common-server-swap.nix
    # ../../modules/common-snapshots.nix

    ##################################################
    # Server-only moduly
    ##################################################
    ../../modules/server/server-apps.nix
    # ../../modules/server/libvirt.nix
    ../../modules/server/cockpit.nix
    # ../../modules/server/zfs.nix
    # ../../auto-upgrade.nix

    ##################################################
    # Server-networking
    ##################################################
    # ../../modules/server/br0-domaPcServer.nix

    ##################################################
    # NSPAWN containers
    ##################################################
    # ../../containers/ha-doma/container.nix
    # ../../containers/caddy/container.nix
    # ../../containers/zigbee2mqtt/container.nix
    # ../../containers/jellyfin/container.nix
    # ../../containers/frigate/container.nix
  ];

  ## =========================
  ## ZÁKLADNÍ NASTAVENÍ
  ## =========================

  networking.hostName = "domaPcServer";

  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "cs_CZ.UTF-8";

  console.keyMap = "cz";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  ## =========================
  ## BOOTLOADER
  ## =========================

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi = {
    canTouchEfiVariables = true;

    # EFI oddíl je připojen přímo do /boot.
    efiSysMountPoint = "/boot";
  };

  ## =========================
  ## LUKS – ŠIFROVANÝ ROOT
  ## =========================
  #
  # Root filesystem je na:
  #
  #   /dev/nvme0n1p2
  #
  # LUKS UUID:
  #
  #   5a775301-f99e-4b41-9332-dbbfc8947db6
  #
  # Keyfile je uložen na EFI oddílu:
  #
  #   /boot/crypto_keyfile.bin
  #
  # Při sestavení systému je keyfile vložen do initrd jako:
  #
  #   /crypto_keyfile.bin
  #
  # Původní LUKS heslo ponechat jako záložní možnost
  # ručního odemčení disku.

  boot.initrd.luks.devices."cryptroot" = {
    device =
      "/dev/disk/by-uuid/5a775301-f99e-4b41-9332-dbbfc8947db6";

    # Server nepoužívá LVM.
    # Proto zde není potřeba:
    #
    # preLVM = true;

    keyFile = "/crypto_keyfile.bin";
  };

  boot.initrd.secrets = {
    "/crypto_keyfile.bin" =
      "/boot/crypto_keyfile.bin";
  };

  ## =========================
  ## UŽIVATEL
  ## =========================

  users.users.gregor = {
    isNormalUser = true;

    # Pouze pro první přihlášení po instalaci.
    #
    # Po základním rozběhu serveru nastav heslo:
    #
    #   passwd gregor
    #
    # a následně initialPassword z konfigurace odstraň.

    initialPassword = "zmenit";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  ## =========================
  ## VIDEO DISK (XFS → /video)
  ## =========================
  #
  # Přidat až po základním rozběhu systému
  # a ověření správného UUID.
  #
  # Aktuální disky lze ověřit:
  #
  #   lsblk -f
  #
  # fileSystems."/video" = {
  #   device =
  #     "/dev/disk/by-uuid/4cf97703-5ef4-43e0-a73a-b1b2fcdc133d";
  #
  #   fsType = "xfs";
  #
  #   options = [
  #     "noatime"
  #     "nofail"
  #   ];
  # };

  ## =========================
  ## ZFS
  ## =========================
  #
  # ZFS ponecháme připravené, ale pooly přidáme
  # až po základním rozběhu systému a ověření:
  #
  #   zpool import
  #
  #   zpool status
  #
  #   zfs list
  #
  # Potom lze aktivovat například:
  #
  # boot.supportedFilesystems = [
  #   "zfs"
  # ];
  #
  # boot.zfs.extraPools = [
  #   "datapool"
  # ];
  #
  # Pro ZFS musí být hostId stabilní a unikátní
  # pro tento server.
  #
  # Před aktivací ZFS vytvořit nebo ověřit:
  #
  #   hostid
  #
  # Nepoužívat obecnou hodnotu typu:
  #
  #   deadbeef
  #
  # networking.hostId = "xxxxxxxx";
  #
  # services.zfs.autoScrub.enable = true;
  #
  # services.zfs.autoSnapshot.enable = true;

  ## =========================
  ## SMART MONITORING DISKŮ
  ## =========================

  services.smartd = {
    enable = true;
    autodetect = true;

    notifications.mail.enable = false;
  };

  ## =========================
  ## SSD / NVMe TRIM
  ## =========================

  services.fstrim.enable = true;

  ## =========================
  ## OCHRANA PAMĚTI – EARLYOOM
  ## =========================

  services.earlyoom = {
    enable = true;

    freeMemThreshold = 5;

    freeSwapThreshold = 10;
  };

  ## =========================
  ## SÍŤ A BEZPEČNÉ DEFAULTY
  ## =========================

  networking.firewall.enable = true;

  services.resolved.enable = true;

  networking.useHostResolvConf = false;

  ## =========================
  ## NIXOS KOMPATIBILITA
  ## =========================

  system.stateVersion = "26.05";
}