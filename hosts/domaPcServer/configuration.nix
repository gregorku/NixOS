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
  ## BOOTLOADER A JÁDRO
  ## =========================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  # Podpora pro Google Coral (Gasket driver + Apex module)
  boot.extraModulePackages = [ config.boot.kernelPackages.gasket ];
  boot.kernelModules = [ "gasket" "apex" ];

  ## =========================
  ## UŽIVATEL
  ## =========================
  users.users.gregor = {
    isNormalUser = true;
    initialPassword = "zmenit";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "render"   # Pro přístup k akceleraci (Coral/GPU)
      "plugdev"  # Pro USB zařízení
    ];
  };

  ## =========================
  ## HARDWARE / USB (Google Coral)
  ## =========================
  services.udev.extraRules = ''
    # Google Coral USB Accelerator (před a po inicializaci firmwaru)
    SUBSYSTEM=="usb", ATTR{idVendor}=="1a6e", ATTR{idProduct}=="089a", GROUP="render", MODE="0660"
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="9302", GROUP="render", MODE="0660"
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
  boot.zfs.extraPools = [ "datapool" ];
  networking.hostId = "deadbeef"; # Nutné pro stabilitu ZFS

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  ## =========================
  ## MONITORING A ÚDRŽBA
  ## =========================
  services.smartd = {
    enable = true;
    autodetect = true;
    notifications.mail.enable = false;
  };

  services.fstrim.enable = true;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };

  ## =========================
  ## SÍŤ A BEZPEČNOST
  ## =========================
  networking.firewall.enable = true;
  services.resolved.enable = true;
  networking.useHostResolvConf = false;

  ## =========================
  ## NIXOS KOMPATIBILITA
  ## =========================
  system.stateVersion = "25.11";
}