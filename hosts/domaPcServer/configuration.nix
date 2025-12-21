{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

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

    ##################################################
    # Server-networking
    ##################################################
    ../../modules/server/br0-domaPcServer.nix

  ];

  ## =========================
  ## ZÁKLADNÍ NASTAVENÍ
  ## =========================

  networking.hostName = "domaPcServer";
  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "cs_CZ.UTF-8";
  console.keyMap = "cz";

  ## =========================
  ## BOOTLOADER
  ## =========================

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

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
    ];
  };

  ## =========================
  ## ZFS – EXTRA POOLY
  ## =========================
  services.zfs = {
    autoImport.enable = true;
    autoScrub.enable = true;
    trim.enable = true;
  };

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
  ## BEZPEČNÉ DEFAULTY
  ## =========================

  networking.firewall.enable = true;

  ## =========================
  ## NIXOS KOMPATIBILITA
  ## =========================

  system.stateVersion = "24.05";
}
