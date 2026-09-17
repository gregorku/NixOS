{
  config,
  pkgs,
  lib,
  unstable,
  ...
}: {
  # ============================================================
  # NIXPKGS / MODULY
  # ============================================================

  _module.args = {
    inherit unstable;
  };

  nixpkgs.config.allowUnfree = true;

  # Fish musí být povolený systémově, protože je nastavený
  # jako login shell uživatele gregor.
  #
  # Samotnou konfiguraci Fish spravuje Home Manager.
  programs.fish.enable = true;

  imports = [
    ./hardware-configuration.nix

    # ----------------------------------------------------------
    # ZÁKLADNÍ SYSTÉMOVÉ MODULY
    # ----------------------------------------------------------

    ../../modules/common-users.nix
    ../../modules/common-desktop-kde.nix
    ../../modules/common-securityPc.nix
    ../../modules/common-bluetooth.nix
    ../../modules/common-printing.nix
    ../../modules/common-apps.nix
    ../../modules/common-flatpak.nix
    ../../modules/common-appimage.nix
    ../../modules/common-filesystems.nix
    ../../modules/common-snapshots.nix
    ../../modules/gpu-amd.nix

    # ../../modules/common-virtualization.nix

    ../../modules/common-swap.nix

    # ----------------------------------------------------------
    # WIREGUARD
    # ----------------------------------------------------------

    # ../../modules/common-wireguard.nix
    # ../../modules/hosts/pracovniPc-wireguard.nix

    # ----------------------------------------------------------
    # SÍŤ
    # ----------------------------------------------------------

    ../../modules/common-networkmanager.nix

    # ----------------------------------------------------------
    # VZDÁLENÝ PŘÍSTUP
    # ----------------------------------------------------------

    ../../modules/common-remote-access.nix
  ];

  # ============================================================
  # SÍŤ
  # ============================================================

  networking = {
    hostName = "pracovniPc";

    # ❗ vypnout NetworkManager (nutné pro bridge)
    # networkmanager.enable = false;

    # unikátní pro každý server
    hostId = "608ebdb2";
  };

  # ============================================================
  # SSH
  # ============================================================

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true; # později vypnout
    };
  };

  # ============================================================
  # LOKALIZACE / JAZYK
  # ============================================================

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

  # ============================================================
  # AGENIX
  # ============================================================

  environment.sessionVariables = {
    AGENIX_AGE_KEY_FILE = "/home/gregor/.config/age/keys.txt";
    AGE_KEY_FILE = "/home/gregor/.config/age/keys.txt";
  };

  # ============================================================
  # NIX OPTIMALIZACE
  # ============================================================

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

  # ============================================================
  # ZFS
  # ============================================================
  #
  # Import datapool po bootu.
  #
  # Ověřeno:
  #   Linux       7.2.5
  #   OpenZFS     2.4.4
  #   zfs_2_4     meta.broken = false
  #

  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs.forceImportRoot = false;

  boot.zfs.extraPools = [
    "DataDisk"
    "FastPool"
  ];

  services.zfs.autoScrub.enable = false;
  services.zfs.autoSnapshot.enable = false;

  # ============================================================
  # KERNEL
  # ============================================================
  #
  # Linux 7.2 – aktuálně používaná verze.
  #
  # linuxPackages_latest zde nepoužívat kvůli ZFS.
  #
  # Konkrétně flake poskytuje:
  #   Linux 7.2.5
  #   ZFS 2.4.4
  #
  # Kombinace je v aktuálním nixpkgs označena jako podporovaná.
  #

  boot.kernelPackages = pkgs.linuxPackages_7_2;

  # ============================================================
  # BOOTLOADER
  # ============================================================

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  # ============================================================
  # ODEZVA SYSTÉMU PŘI VELKÉM ZÁPISU
  # ============================================================

  boot.kernel.sysctl = {
    "vm.dirty_background_ratio" = 3;
    "vm.dirty_ratio" = 6;
    "vm.dirty_expire_centisecs" = 3000;
    "vm.dirty_writeback_centisecs" = 500;
  };

  # ============================================================
  # POVINNÉ – NIKDY NEMĚNIT PO INSTALACI
  # ============================================================

  system.stateVersion = "26.05";
}