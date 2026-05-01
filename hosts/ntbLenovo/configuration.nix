{ config, pkgs, lib, unstable, ... }:
{
  _module.args = { inherit unstable; };

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

    ../../modules/notebook-power.nix
    ../../modules/common-virtualization.nix
    ../../modules/common-incus.nix
    ../../modules/common-swap.nix
    ../../modules/common-networkmanager.nix
  ];

  networking.hostName = "ntbLenovo";

  #incus vypnutí minio, jinak nefunguje rebuild
  nixpkgs.config.permittedInsecurePackages = [
    "minio-2025-10-15T17-29-55Z"
  ];

  # ----------------------
  # 🌍 Lokalizace
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
  # 🐟 FISH + CLI
  # ----------------------
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
      alias rebuild="sudo nixos-rebuild switch"

      set -g fish_greeting ""
    '';
  };

  # ----------------------
  # ⭐ STARSHIP
  # ----------------------
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

  # ----------------------
  # 🎨 CATPPUCCIN
  # ----------------------
  environment.systemPackages = with pkgs; [
    catppuccin-gtk
    papirus-icon-theme
    hicolor-icon-theme
    adwaita-icon-theme

    zoxide
    fzf
    eza
    bat
    ripgrep
    fd
    tmux
    lazygit

    kdePackages.kde-gtk-config
    gsettings-desktop-schemas

    nixd
    nixfmt

   # ----------------------  
   # media player Jellyfin
   # ---------------------- 
    jellyfin-media-player

  ];

  environment.pathsToLink = [ "/share/icons" "/share/themes" ];

  environment.variables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
    EDITOR = "nano";
    SAL_USE_VCLPLUGIN = "kf6";
    GTK2_RC_FILES = "${pkgs.catppuccin-gtk}/share/themes/Catppuccin-Mocha-Standard-Blue-Dark/gtk-2.0/gtkrc";
  };

  environment.sessionVariables = {
    AGENIX_AGE_KEY_FILE = "/home/gregor/.config/age/keys.txt";
    AGE_KEY_FILE = "/home/gregor/.config/age/keys.txt";
  };

  # ----------------------
  # 🐱 KITTY
  # ----------------------
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

  # ----------------------
  # 💾 disk DataLinux (LUKS + Btrfs)
  # ----------------------

  # 🔐 LUKS auto unlock
  boot.initrd.luks.devices."data_crypt" = {
    device = "/dev/disk/by-uuid/b56c0b20-f566-44b5-8f81-54bbcd61cf10";
    keyFile = "/root/keys/data.key";
    allowDiscards = true;
  };

  # 🔑 keyfile dostupný v initrd
  boot.initrd.secrets = {
    "/root/keys/data.key" = /root/keys/data.key;
  };

  # 📂 mount DataLinux (stejné místo jako dřív)
  fileSystems."/run/media/gregor/DataLinux" = {
    device = "/dev/mapper/data_crypt";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "nofail"
      "commit=120"
    ];
  };

  # ----------------------
  # 🔊 AMD Audio fix (Legion 5 ACH6H)
  # ----------------------
  hardware.firmware = [ pkgs.sof-firmware ];

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

  # ----------------------
  # 🔧 NIX OPTIMALIZACE
  # ----------------------
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # ----------------------
  # 🔧 SYSTEM
  # ----------------------

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.libinput.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # 🧠 Lepší odezva při velkém zápisu
  boot.kernel.sysctl = {
    "vm.dirty_background_ratio" = 3;
    "vm.dirty_ratio" = 6;
    "vm.dirty_expire_centisecs" = 3000;
    "vm.dirty_writeback_centisecs" = 500;
  };

  system.stateVersion = "25.11";
}