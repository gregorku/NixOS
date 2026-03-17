{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix

    ../../modules/common-users.nix
    ../../modules/common-audio.nix
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

  # ----------------------
  # 🔧 FIX: suspend / input (Lenovo Legion)
  # ----------------------
  boot.kernelParams = [
    "i8042.nopnp=1"
    "i8042.reset"
    "pci=nocrs"
    "usbcore.autosuspend=-1"
  ];

  services.libinput.enable = true;

  # 🔧 HARD FIX – reload touchpadu po probuzení
  systemd.services.fix-touchpad = {
    description = "Fix touchpad after suspend";
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.kmod}/bin/modprobe -r i2c_hid_acpi
        ${pkgs.kmod}/bin/modprobe i2c_hid_acpi
      '';
    };
  };

  # ----------------------
  # disk DataLinux
  # ----------------------
  fileSystems."/run/media/gregor/DataLinux" = {
    device = "/dev/disk/by-uuid/b38e75c9-a885-4713-aa6f-d5ea8a0fde1a";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "nofail"
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