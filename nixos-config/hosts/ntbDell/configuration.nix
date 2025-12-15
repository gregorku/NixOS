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
  ];

  networking.hostName = "ntbDell";

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
