{ config, pkgs, lib, unstable, ... }:
{
  _module.args = { inherit unstable; };

  nixpkgs.config.allowUnfree = true;
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
    ../../modules/gpu-amd.nix
    #../../modules/common-virtualization.nix
    ../../modules/common-swap.nix
    # Modul Wireguard
    #../../modules/common-wireguard.nix
    #../../modules/hosts/pracovniPc-wireguard.nix
    ../../modules/common-networkmanager.nix

  ];

  networking.hostName = "pracovniPc";

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
      # 🔨 Rebuild tohoto notebooku
      alias rebuild="sudo nixos-rebuild switch --flake /etc/nixos#ntbLenovo"

      set -g fish_greeting ""
    '';
  };

  # ----------------------
  # STARSHIP
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
  # CATPPUCCIN + nástroje
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

    nixd
    nixfmt

   # ----------------------  
   # media player Jellyfin
   # ---------------------- 
    jellyfin-media-player

   # ----------------------  
   # Python
   # ---------------------- 
   (python3.withPackages (ps: with ps; [
    pandas
    openpyxl
   ]))

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
  # KITTY
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
  # Kernel latest
  boot.kernelPackages = pkgs.linuxPackages_latest;
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
