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
    ../../modules/common-virtualization.nix
    ../../modules/common-swap.nix
  ];

  networking.hostName = "ntbDell";

  # 🔑 POVINNÉ – bootloader (EFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 🔑 POVINNÉ – NIKDY POZDĚJI NEMĚNIT
  system.stateVersion = "24.05";
}
