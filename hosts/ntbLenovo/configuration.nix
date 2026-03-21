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

    ../../modules/notebook-power.nix
    ../../modules/common-virtualization.nix
    ../../modules/common-swap.nix
    ../../modules/common-networkmanager.nix
  ];

  networking.hostName = "ntbLenovo";

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
  # 🐟 Fish + UX upgrade
  # ----------------------
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # ⭐ Starship
      set -gx STARSHIP_CONFIG /etc/starship.toml
      ${pkgs.starship}/bin/starship init fish | source

      # ⚡ zoxide (lepší cd)
      ${pkgs.zoxide}/bin/zoxide init fish | source

      # 🔍 fzf keybindings
      ${pkgs.fzf}/bin/fzf --fish | source

      # Aliasy
      alias ll="ls -lah"
      alias rebuild="sudo nixos-rebuild switch"
      alias cd="z"   # 🔥 automatické cd

      set -g fish_greeting ""
    '';
  };

  # ----------------------
  # ⭐ Starship (hezký theme)
  # ----------------------
  programs.starship.enable = true;

  environment.etc."starship.toml".text = ''
    add_newline = false

    format = "$username$hostname $directory $git_branch $git_status $cmd_duration $character"

    [username]
    show_always = true
    style_user = "bold green"

    [hostname]
    ssh_only = false
    format = "@$hostname"
    style = "bold cyan"

    [directory]
    style = "bold blue"
    truncation_length = 3

    [git_branch]
    symbol = "🌱 "
    style = "bold yellow"

    [git_status]
    style = "red"

    [cmd_duration]
    min_time = 500
    format = "⏱ $duration "
    style = "yellow"

    [character]
    success_symbol = "[➜](bold green)"
    error_symbol = "[✗](bold red)"
  '';

  # ----------------------
  # 📦 CLI nástroje
  # ----------------------
  environment.systemPackages = with pkgs; [
    zoxide
    fzf
    eza   # lepší ls
    bat   # lepší cat
  ];

  # ----------------------
  # 🐱 Kitty
  # ----------------------
  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family FiraCode Nerd Font
    font_size 12
    background_opacity 0.92

    confirm_os_window_close 0
    enable_audio_bell no
    copy_on_select yes
    scrollback_lines 10000

    # padding (lepší vzhled)
    window_padding_width 8

    # splits
    map ctrl+alt+enter launch --location=hsplit
    map ctrl+alt+v launch --location=vsplit

    # navigation
    map ctrl+alt+h neighboring_window left
    map ctrl+alt+l neighboring_window right
    map ctrl+alt+k neighboring_window up
    map ctrl+alt+j neighboring_window down
  '';

  # ----------------------
  # 🔧 System
  # ----------------------
  boot.kernelParams = [ "pci=nocrs" ];
  services.libinput.enable = true;

  fileSystems."/run/media/gregor/DataLinux" = {
    device = "/dev/disk/by-uuid/b38e75c9-a885-4713-aa6f-d5ea8a0fde1a";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "space_cache=v2" "nofail" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";
}