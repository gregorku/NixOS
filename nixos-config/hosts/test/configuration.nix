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
    ../../modules/gpu-nvidia-amd.nix
    ../../modules/common-virtualization.nix
    ../../modules/common-swap.nix
  ];

  networking.hostName = "test";
}
