{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/zfs.nix
    ../../modules/common-server-swap.nix
    ../../modules/common-snapshots.nix

    ../../modules/common-networkmanager.nix
    ../../modules/common-security.nix

    ../../modules/cockpit.nix
    ../../modules/libvirt.nix
    ../../modules/server-apps.nix
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
  ## BEZPEČNÉ DEFAULTY
  ## =========================

  networking.firewall.enable = true;

  ## =========================
  ## NIXOS KOMPATIBILITA
  ## =========================

  system.stateVersion = "24.05";
}
