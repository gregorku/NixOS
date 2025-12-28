{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    /etc/nixos/secrets/ssh

    ##################################################
    # Common – sdílené moduly
    ##################################################
    ../../modules/common-security.nix
    ../../modules/common-server-swap.nix
    ../../modules/common-snapshots.nix

    ##################################################
    # Server-only moduly
    ##################################################
    ../../modules/server/server-apps.nix
    ../../modules/server/libvirt.nix
    ../../modules/server/cockpit.nix
    ../../modules/server/zfs.nix
    ../../auto-upgrade.nix

    ##################################################
    # Server-networking
    ##################################################
    ../../modules/server/br0-domaPcServer.nix

    ##################################################
    # NSPAWN containers
    ##################################################
    ../../containers/ha-doma/container.nix
    ../../containers/caddy/container.nix
    ../../containers/zigbee2mqtt/container.nix
    ../../containers/jellyfin/container.nix
    ../../containers/frigate/container.nix
  ];

  ## =========================
  ## ZÁKLADNÍ NASTAVENÍ
  ## =========================
  networking.hostName = "domaPcServer";
  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "cs_CZ.UTF-8";
  console.keyMap = "cz";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ## =========================
  ## BOOTLOADER
  ## =========================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  ## =========================
  ## UŽIVATEL A SKUPINY
  ## =========================
  users.groups.plugdev = {}; # Skupina pro přístup k USB zařízením

  users.users.gregor = {
    isNormalUser = true;
    initialPassword = "zmenit";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "plugdev"
    ];
  };

  ## =========================
  ## UDEV PRAVIDLA (Google Coral)
  ## =========================
  services.udev.extraRules = ''
    # Google Coral USB (inicializační stav)
    SUBSYSTEM=="usb", ATTRS{idVendor} == "1a6e", ATTRS{idProduct} == "089a", GROUP="plugdev", MODE="0660"
    # Google Coral USB (stav po načtení firmware)
    SUBSYSTEM=="usb", ATTRS{idVendor} == "18d1", ATTRS{idProduct} == "9302", GROUP="plugdev", MODE="0660"
  '';

  ## =========================
  ## VIDEO DISK (sdb → /video)
  ## =========================
  fileSystems."/video" = {
    device = "/dev/disk/by-uuid/4cf97703-5ef4-43e0-a73a-b1b2fcdc133d";
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
  boot.zfs.extraPools = [ "datapool" ]; # Explicitní import
  networking.hostId = "deadbeef"; # Nutné pro stabilitu

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  ## =========================
  ## SMART monitoring disků (KRITICKÉ)
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
  ## Ochrana paměti (earlyoom)
  ## =========================
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };

  ## =========================
  ## BEZPEČNÉ DEFAULTY
  ## =========================
  networking.firewall.enable = true;
  services.resolved.enable = true;
  networking.useHostResolvConf = false;

  ## =========================
  ## NIXOS KOMPATIBILITA
  ## =========================
  system.stateVersion = "25.11";
}