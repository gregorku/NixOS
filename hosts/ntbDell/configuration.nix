{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common-users.nix
    ../../modules/common-desktop-kde.nix
    ../../modules/common-security.nix
    ../../modules/common-bluetooth.nix
    ../../modules/common-printing.nix
    ../../modules/common-apps.nix
    ../../modules/common-flatpak.nix
    ../../modules/common-filesystems.nix
    ../../modules/common-snapshots.nix
    ../../modules/gpu-intel.nix

    ../../modules/notebook-power.nix
    ../../modules/common-virtualization.nix
    ../../modules/common-swap.nix

    #../../modules/common-wireguard.nix
    #../../modules/hosts/ntbDell-wireguard.nix
    ../../modules/common-networkmanager.nix
  ];

  networking.hostName = "ntbDell";
  networking.hostId = "94fb7b0f";  # Povinné pro ZFS

  # ----------------------
  # Lokalizace / Jazyk
  # ----------------------
  i18n.defaultLocale = "cs_CZ.UTF-8";
  i18n.supportedLocales = [
    "cs_CZ.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  time.timeZone = "Europe/Prague";

  console.keyMap = "cz";

  services.xserver = {
    layout = "cz";
    xkbVariant = "";
  };

  ##################################################
  # ZFS
  ##################################################

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  services.zfs.autoScrub.enable = true;

  ##################################################
  # LUKS šifrování
  ##################################################

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/4893827c-78f1-4841-99ef-5805fbc37b06";
    preLVM = true;
  };

  ##################################################
  # BOOTLOADER – DUAL BOOT (Windows 11 + NixOS)
  ##################################################

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
  };

  ##################################################
  # POVINNÉ – NIKDY NEMĚNIT PO INSTALACI
  ##################################################

  system.stateVersion = "25.11";
}