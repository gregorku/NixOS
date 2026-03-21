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
  # 🐟 Fish shell
  # ----------------------
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # ⭐ Starship (správná aktivace)
      set -x STARSHIP_CONFIG /etc/starship.toml
      ${pkgs.starship}/bin/starship init fish | source

      alias ll="ls -lah"
      alias rebuild="sudo nixos-rebuild switch"

      set -g fish_greeting ""
    '';
  };

  # ----------------------
  # ⭐ Starship
  # ----------------------
  programs.starship.enable = true;

  environment.etc."starship.toml".text = ''
    add_newline = false

    format = "$username@$hostname $directory $git_branch $git_status $character"

    [character]
    success_symbol = "[➜](green)"
    error_symbol = "[✗](red)"

    [directory]
    style = "blue"
    truncation_length = 3

    [git_branch]
    symbol = "🌱 "
    style = "yellow"

    [git_status]
    style = "red"

    [username]
    style_user = "green"
    show_always = true

    [hostname]
    style = "bold green"
  '';

  # ----------------------
  # 🐱 Kitty Terminal
  # ----------------------
  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family FiraCode Nerd Font
    font_size 12
    background_opacity 0.9
    confirm_os_window_close 0
    enable_audio_bell no
    copy_on_select yes
    scrollback_lines 10000

    map ctrl+alt+enter launch --location=hsplit
    map ctrl+alt+v launch --location=vsplit
    map ctrl+alt+h neighboring_window left
    map ctrl+alt+l neighboring_window right
    map ctrl+alt+k neighboring_window up
    map ctrl+alt+j neighboring_window down
  '';

  # ----------------------
  # 🔧 Systém / Boot
  # ----------------------
  boot.kernelParams = [ "pci=nocrs" ];
  services.libinput.enable = true;

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";
}