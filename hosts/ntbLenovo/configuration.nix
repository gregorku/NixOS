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
  # 🐟 FISH + CLI
  # ----------------------
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx STARSHIP_CONFIG /etc/starship.toml

      ${pkgs.starship}/bin/starship init fish | source
      ${pkgs.zoxide}/bin/zoxide init fish | source
      ${pkgs.fzf}/bin/fzf --fish | source

      alias ll="eza -lah"
      alias cat="bat"
      alias cd="z"
      alias rebuild="sudo nixos-rebuild switch"

      # 🔥 VPN
      alias vpn-work="sudo openconnect --user=kutik --authgroup=UADFD01-ST-2FA --servercert pin-sha256:Myb+eKrw7BcomYOUYcpUvpfhLaZ84nQDygatExjB44U= --mtu 1200 --script='vpn-slice --no-host-names --no-ns-hosts --nbns 10.0.0.0/8' u.ivpn.cz"
      alias vpn-off="sudo killall openconnect"

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

    zoxide
    fzf
    eza
    bat
    ripgrep
    fd
    tmux
    lazygit
  ];

  environment.variables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
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

    map ctrl+alt+enter launch --location=hsplit
    map ctrl+alt+v launch --location=vsplit
  '';

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
  # 🔧 SYSTEM
  # ----------------------
  boot.kernelParams = [ "pci=nocrs" ];
  services.libinput.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";
}