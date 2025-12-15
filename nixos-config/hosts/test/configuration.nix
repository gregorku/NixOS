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

    # GPU – test stroj (kombinovaný profil)
    ../../modules/gpu-nvidia-amd.nix

    ../../modules/common-virtualization.nix
    ../../modules/common-swap.nix
  ];

  # ----------------------
  # Host identity
  # ----------------------
  networking.hostName = "test";

  # ----------------------
  # Lokalizace / Jazyk
  # ----------------------
  i18n.defaultLocale = "cs_CZ.UTF-8";

  i18n.supportedLocales = [
    "cs_CZ.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  time.timeZone = "Europe/Prague";

  console = {
    keyMap = "cz";
  };

  services.xserver = {
    layout = "cz";
    xkbVariant = "";
  };

  # ----------------------
  # Bootloader (UEFI)
  # ----------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ----------------------
  # Povinné – NIKDY neměnit po instalaci
  # ----------------------
  system.stateVersion = "25.05";
}
