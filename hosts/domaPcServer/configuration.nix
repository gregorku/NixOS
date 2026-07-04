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
    ../../modules/server/server-base.nix
    # ../../modules/server/libvirt.nix
    ../../modules/server/cockpit.nix
    # ../../modules/server/zfs.nix
    # ../../auto-upgrade.nix

    ##################################################
    # Server-networking
    ##################################################
    ../../modules/server/server-br0.nix

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

    #initialPassword = "zmenit";

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
  fileSystems."/hdd-disk/video" = {
    device =
      "/dev/disk/by-uuid/203f383c-f1b8-4a8e-8687-abeb29bd1721";
  
    fsType = "xfs";
  
    options = [
      "noatime"
      "nofail"
    ];
  };

  ## =========================
  ## ZFS – import datapool po bootu
  ## =========================
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [
  "datapool"
  "zfs-NVME-4TB"
  ];
  boot.zfs.forceImportRoot = false; # Doporučeno od NixOS 26.11

  services.zfs.autoScrub.enable = false;
  services.zfs.autoSnapshot.enable = false;

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

  # ─────────────────────────────────────
  # 🌐 SÍŤ
  # ─────────────────────────────────────

  networking = {
    hostName = "domaPcServer";

    # NetworkManager musí být vypnutý,
    # protože bridge br0 spravuje síťový modul.
    networkmanager.enable = false;

    # Unikátní hostId pro tento server.
    # Důležité také pro pozdější použití ZFS.
    hostId = "f474d573";

    firewall.enable = true;

    useHostResolvConf = false;
  };

  services.resolved.enable = true;

  # ----------------------
  # Bridge br0 (LAN)
  # ----------------------

  server.br0 = {
    enable = true;

    # Fyzické LAN rozhraní tohoto serveru.
    interface = "enp7s0";
  };

  ## =========================
  ## NIXOS KOMPATIBILITA
  ## =========================

  system.stateVersion = "26.05";
}