{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

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
    ../../modules/gpu-nvidia-amd.nix

    # Notebook-specific power optimizations
    ../../modules/notebook-power.nix

    ../../modules/common-virtualization.nix
    ../../modules/common-swap.nix

    # Modul Wireguard
    #../../modules/common-wireguard.nix
    #../../modules/hosts/ntbLenovo-wireguard.nix
    ../../modules/common-networkmanager.nix

  ];

  networking.hostName = "ntbLenovo";

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

  services.xserver.xkb = {
    layout = "cz";
    variant = "";
  };
  #disk DataLinux
  fileSystems."/mnt/DataLinux" = {
  device = "/dev/disk/by-uuid/b38e75c9-a885-4713-aa6f-d5ea8a0fde1a";
  fsType = "btrfs";
  options = [
    "compress=zstd"
    "noatime"
  ];
  };
  # ----------------------
  # Bootloader (UEFI)
  # ----------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ----------------------
  # Povinné – NIKDY neměnit po instalaci
  # ----------------------
  system.stateVersion = "25.11";
}
