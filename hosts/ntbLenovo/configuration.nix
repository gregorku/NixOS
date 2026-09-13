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

  # Fish je systémově zapnutý, protože je nastaven jako
  # login shell uživatele gregor.
  programs.fish.enable = true;

  imports = [
    ./hardware-configuration.nix

    # ----------------------------------------------------------
    # ZÁKLADNÍ SYSTÉMOVÉ MODULY
    # ----------------------------------------------------------

    ../../modules/common-users.nix
    ../../modules/common-audio.nix
    ../../modules/common-desktop-kde.nix
    ../../modules/common-securityPc.nix
    ../../modules/common-bluetooth.nix
    ../../modules/common-printing.nix
    ../../modules/common-apps.nix
    ../../modules/common-flatpak.nix
    ../../modules/common-appimage.nix
    ../../modules/common-filesystems.nix
    ../../modules/common-snapshots.nix
    ../../modules/gpu-nvidia-amd.nix

    # ----------------------------------------------------------
    # NOTEBOOK
    # ----------------------------------------------------------

    ../../modules/notebook-power.nix

    # ----------------------------------------------------------
    # SÍŤ / SWAP
    # ----------------------------------------------------------

    ../../modules/common-swap.nix
    ../../modules/common-networkmanager.nix

    # ----------------------------------------------------------
    # VIRTUALIZACE / INCUS
    #
    # ZATÍM VYPNUTO.
    #
    # Vrátíme po prvním úspěšném bootu a základní kontrole
    # systému.
    # ----------------------------------------------------------

    # ../../modules/common-virtualization.nix
    # ../../modules/common-incus.nix
  ];

  # ============================================================
  # HOSTNAME
  # ============================================================

  networking.hostName = "ntbLenovo";

  # ============================================================
  # AGENIX
  #
  # ZATÍM VYPNUTO.
  #
  # Vyžaduje soubory ze secrets/ a konfiguraci klíčů.
  # Aktivujeme až po dokončení základní instalace.
  # ============================================================

  #/*
  age.secrets.aider-openrouter = {
    file = ../../secrets/AI/openrouter-aider.age;
    owner = "gregor";
    group = "users";
    mode = "0400";
  };
  #*/

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
  # AGENIX – PROMĚNNÉ PRO KLÍČE
  #
  # ZATÍM VYPNUTO.
  # ============================================================

  #/*
  environment.sessionVariables = {
    AGENIX_AGE_KEY_FILE = "/home/gregor/.application-data/agenix/keys.txt";
    AGE_KEY_FILE = "/home/gregor/.application-data/agenix/keys.txt";
  };
  #*/

  # ============================================================
  # DATALINUX – DRUHÝ DISK
  #
  # Samsung 990 EVO 2TB
  #
  # ZATÍM VYPNUTO.
  #
  # Druhý disk zprovozníme až po prvním úspěšném bootu.
  # Konfiguraci nemažeme, pouze ji ponecháváme zakomentovanou.
  # ============================================================

  #/*
  boot.initrd.luks.devices."data_crypt" = {
    device = "/dev/disk/by-uuid/b56c0b20-f566-44b5-8f81-54bbcd61cf10";
    keyFile = "/root/keys/data.key";
    allowDiscards = true;
  };

  boot.initrd.secrets = {
    "/root/keys/data.key" = /root/keys/data.key;
  };

  fileSystems."/run/media/gregor/DataLinux" = {
    device = "/dev/mapper/data_crypt";
    fsType = "btrfs";

    options = [
      "compress=zstd"
      "noatime"
      "nofail"
      "commit=120"
    ];
  };
  #*/

  # ============================================================
  # LEGION 5 – AMD AUDIO FIX
  # ============================================================

  hardware.firmware = [
    pkgs.sof-firmware
  ];

  boot.blacklistedKernelModules = [
    "snd_pci_acp5x"
    "snd_rn_pci_acp3x"
  ];

  boot.kernelModules = [
    "snd_hda_intel"
  ];

  boot.kernelParams = [
    "snd_hda_intel.dmic_detect=0"
  ];

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
  # SYSTEM
  # ============================================================

  # ------------------------------------------------------------
  # Kernel
  #
  # Používáme výchozí kernel.
  # ------------------------------------------------------------

  boot.kernelPackages = pkgs.linuxPackages_7_2;

  # ------------------------------------------------------------

  services.libinput.enable = true;

  # ------------------------------------------------------------
  # systemd-boot
  # ------------------------------------------------------------

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # ------------------------------------------------------------
  # Odezva systému při velkém zápisu
  # ------------------------------------------------------------

  boot.kernel.sysctl = {
    "vm.dirty_background_ratio" = 3;
    "vm.dirty_ratio" = 6;
    "vm.dirty_expire_centisecs" = 3000;
    "vm.dirty_writeback_centisecs" = 500;
  };

  # ============================================================
  # NIXOS STATE VERSION
  # ============================================================

  system.stateVersion = "26.05";
}
