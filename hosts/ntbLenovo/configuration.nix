{
  config,
  pkgs,
  lib,
  unstable,
  ...
}:
{
  # ============================================================
  # NIXPKGS / MODULY
  # ============================================================

  _module.args = {
    inherit unstable;
  };

  nixpkgs.config.allowUnfree = true;

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
  # FISH + CLI
  # ============================================================

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -gx STARSHIP_CONFIG /etc/starship.toml

      ${pkgs.starship}/bin/starship init fish | source
      ${pkgs.zoxide}/bin/zoxide init fish | source
      ${pkgs.fzf}/bin/fzf --fish | source

      if set -q SSH_CONNECTION
          set -gx TERM xterm-256color
      end

      alias ll="eza -lah"
      alias cat="bat"
      alias cd="z"

      # Rebuild tohoto notebooku
      alias rebuild="sudo nixos-rebuild switch --flake /etc/nixos#ntbLenovo"

      set -g fish_greeting ""
    '';
  };


  # ============================================================
  # STARSHIP
  # ============================================================

  programs.starship.enable = true;

  environment.etc."starship.toml".text = ''
    add_newline = false
    format = "$username$hostname $directory $git_branch $git_status $cmd_duration $character"

    [username]
    show_always = true
    format = "$user"
    style_user = "#a6e3a1"

    [hostname]
    ssh_only = false
    format = "@$hostname"
    style = "#89b4fa"

    [directory]
    style = "#89b4fa"
    truncation_length = 3

    [git_branch]
    symbol = "🌱 "
    style = "#f9e2af"

    [git_status]
    style = "#f38ba8"

    [cmd_duration]
    min_time = 500
    format = "⏱ $duration "
    style = "#fab387"

    [character]
    success_symbol = "[➜](#a6e3a1)"
    error_symbol = "[✗](#f38ba8)"
  '';


  # ============================================================
  # CATPPUCCIN + SYSTÉMOVÉ NÁSTROJE
  # ============================================================

  environment.systemPackages = with pkgs; [
    # ----------------------------------------------------------
    # Vzhled
    # ----------------------------------------------------------

    catppuccin-gtk
    papirus-icon-theme
    hicolor-icon-theme
    adwaita-icon-theme

    # ----------------------------------------------------------
    # CLI
    # ----------------------------------------------------------

    zoxide
    fzf
    eza
    bat
    ripgrep
    fd
    tmux
    lazygit

    # ----------------------------------------------------------
    # Nix
    # ----------------------------------------------------------

    nixd
    nixfmt

    # ----------------------------------------------------------
    # Jellyfin Media Player
    # ----------------------------------------------------------

    # jellyfin-media-player

    # ----------------------------------------------------------
    # Python
    # Verze 0.3.33 nefunguje
    # ----------------------------------------------------------

    (python3.withPackages (
      ps:
      with ps;
      [
        pandas
        openpyxl
      ]
    ))
  ];

  environment.pathsToLink = [
    "/share/icons"
    "/share/themes"
  ];

  environment.variables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
    EDITOR = "nano";
    SAL_USE_VCLPLUGIN = "kf6";

    GTK2_RC_FILES =
      "${pkgs.catppuccin-gtk}/share/themes/Catppuccin-Mocha-Standard-Blue-Dark/gtk-2.0/gtkrc";
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
  # KITTY
  # ============================================================

  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family FiraCode Nerd Font
    font_size 10

    background_opacity 0.92
    window_padding_width 10

    confirm_os_window_close 0
    enable_audio_bell no
    copy_on_select yes
    scrollback_lines 10000

    term xterm-256color
    enable_kitty_keyboard_protocol no

    map ctrl+alt+enter launch --location=hsplit
    map ctrl+alt+v launch --location=vsplit
  '';


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
  #
  boot.kernelPackages = pkgs.linuxPackages_latest;
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