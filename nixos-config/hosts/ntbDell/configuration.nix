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

    # Notebook-specific power optimizations
    ../../modules/notebook-power.nix

    ../../modules/common-virtualization.nix
    ../../modules/common-swap.nix

    # Modul Wireguard
    #../../modules/common-wireguard.nix
    #../../modules/hosts/ntbDell-wireguard.nix
    ../../modules/common-networkmanager.nix

  ];

  networking.hostName = "ntbDell";

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
  # BOOTLOADER – DUAL BOOT (Windows 11 + NixOS)
  ##################################################

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";          # EFI systém, ne MBR
    useOSProber = true;        # najde Windows Boot Manager
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
  };

  ##################################################
  # POVINNÉ – NIKDY NEMĚNIT PO INSTALACI
  ##################################################

  system.stateVersion = "24.05";
}
