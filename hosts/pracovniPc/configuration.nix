{
  config,
  pkgs,
  lib,
  unstable,
  ...
}:
{
  _module.args = { inherit unstable; };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  imports = [
    ./hardware-configuration.nix

    ../../modules/common-users.nix
    ../../modules/common-desktop-kde.nix
    ../../modules/common-securityPc.nix
    ../../modules/common-bluetooth.nix
    ../../modules/common-printing.nix
    ../../modules/common-apps.nix
    ../../modules/common-flatpak.nix
    ../../modules/common-filesystems.nix
    ../../modules/common-snapshots.nix
    ../../modules/gpu-amd.nix
    #../../modules/common-virtualization.nix
    ../../modules/common-swap.nix
    # Modul Wireguard
    #../../modules/common-wireguard.nix
    #../../modules/hosts/pracovniPc-wireguard.nix
    ../../modules/common-networkmanager.nix
    # Vzdálený přístup
    ../../modules/common-remote-access.nix

  ];

  # ─────────────────────────────────────
  # 🌐 SÍŤ
  # ─────────────────────────────────────
  networking = {
    hostName = "pracovniPc";

    # ❗ vypnout NetworkManager (nutné pro bridge)
    #networkmanager.enable = false;

    # unikátní pro každý server
    hostId = "608ebdb2";
  };

  # ─────────────────────────────────────
  # 🔐 SSH
  # ─────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true; # později vypnout
    };
  };

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
    # media player Jellyfin
    # ----------------------
    jellyfin-media-player

    # ----------------------
    # Python
    # ----------------------
    (python3.withPackages (
      ps: with ps; [
        pandas
        openpyxl
      ]
    ))

  ];


  environment.sessionVariables = {
    AGENIX_AGE_KEY_FILE = "/home/gregor/.config/age/keys.txt";
    AGE_KEY_FILE = "/home/gregor/.config/age/keys.txt";
  };


  # ----------------------
  # 🔧 NIX OPTIMALIZACE
  # ----------------------
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  ## ZFS – import datapool po bootu
  ## =========================
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false; # Doporučeno od NixOS 26.11
  boot.zfs.extraPools = [
    "DataDisk"
    "FastPool"
  ];
  services.zfs.autoScrub.enable = false;
  services.zfs.autoSnapshot.enable = false;

  # Kernel latest nefunkční zfs
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_7_2;  
  # ----------------------
  # Bootloader (UEFI)
  # ----------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ----------------------
  # Povinné – NIKDY neměnit po instalaci
  # ----------------------
  system.stateVersion = "26.05";
}
