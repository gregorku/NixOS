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
  time.timeZone = "Europe/Prague";

  console.keyMap = "cz";

  services.xserver.xkb.layout = "cz";

  # ----------------------
  # 🐟 FISH (ULTIMATE)
  # ----------------------
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Starship
      set -gx STARSHIP_CONFIG /etc/starship.toml
      ${pkgs.starship}/bin/starship init fish | source

      # Zoxide (smart cd)
      ${pkgs.zoxide}/bin/zoxide init fish | source

      # FZF
      ${pkgs.fzf}/bin/fzf --fish | source

      # Aliases
      alias ll="eza -lah"
      alias cat="bat"
      alias cd="z"
      alias rebuild="sudo nixos-rebuild switch"
      alias gs="git status"
      alias gl="git log --oneline --graph"

      set -g fish_greeting ""
    '';
  };

  # ----------------------
  # ⭐ STARSHIP (CATPPUCCIN)
  # ----------------------
  programs.starship.enable = true;

  environment.etc."starship.toml".text = ''
    add_newline = false

    format = "$username$hostname $directory $git_branch $git_status $cmd_duration $character"

    [username]
    show_always = true
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
  # 📦 CLI POWER TOOLS
  # ----------------------
  environment.systemPackages = with pkgs; [
    zoxide
    fzf
    eza
    bat
    ripgrep
    fd
    tmux
    lazygit
    ];

  # ----------------------
  # 🧠 TMUX (IDE v terminalu)
  # ----------------------
  environment.etc."tmux.conf".text = ''
    set -g mouse on
    set -g history-limit 10000

    # splits
    bind | split-window -h
    bind - split-window -v

    # reload
    bind r source-file ~/.tmux.conf \; display "Reloaded!"

    # prefix změna
    unbind C-b
    set -g prefix C-a
    bind C-a send-prefix
  '';

  # ----------------------
  # 🐱 KITTY (PRO LOOK)
  # ----------------------
  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family FiraCode Nerd Font
    font_size 12

    background_opacity 0.92
    window_padding_width 10

    confirm_os_window_close 0
    enable_audio_bell no
    copy_on_select yes
    scrollback_lines 10000

    map ctrl+alt+enter launch --location=hsplit
    map ctrl+alt+v launch --location=vsplit
  '';

  # ----------------------
  # 🔧 SYSTEM
  # ----------------------
  boot.kernelParams = [ "pci=nocrs" ];
  services.libinput.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";
}