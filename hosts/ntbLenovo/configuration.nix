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
  # 🐟 Fish shell & ⭐ Starship integrace
  # ----------------------
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Nastavení cesty ke globálnímu konfiguračnímu souboru Starshipu
      set -x STARSHIP_CONFIG /etc/starship.toml
      
      # Vynucená inicializace Starshipu přes absolutní cestu
      ${pkgs.starship}/bin/starship init fish | source

      alias ll="ls -lah"
      alias rebuild="sudo nixos-rebuild switch"
    '';
  };

  # Aktivuje binárku starshipu v systému
  programs.starship.enable = true;

  # Generování konfiguračního souboru pro Starship do /etc/
  environment.etc."starship.toml".text = ''
    add_newline = false

    format = """
    $username@$hostname $directory $git_branch $git_status
    $character
    """

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
  # 🐱 Kitty Terminal (Globální konfigurace)
  # ----------------------
  environment.etc."xdg/kitty/kitty.conf".text = ''
    # FONT
    font_family FiraCode Nerd Font
    font_size 12

    # VZHLED
    background_opacity 0.9
    confirm_os_window_close 0
    enable_audio_bell no

    # COPY / PASTE
    copy_on_select yes

    # SCROLLBACK
    scrollback_lines 10000

    # SPLIT SHORTCUTS
    map ctrl+alt+enter launch --location=hsplit
    map ctrl+alt+v launch --location=vsplit

    # NAVIGACE MEZI PANELY
    map ctrl+alt+h neighboring_window left
    map ctrl+alt+l neighboring_window right
    map ctrl+alt+k neighboring_window up
    map ctrl+alt+j neighboring_window down
  '';

  # ----------------------
  # 🔧 Lenovo fixy & Systém
  # ----------------------
  boot.kernelParams = [
    "pci=nocrs"
  ];

  services.libinput.enable = true;

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
  # Bootloader (UEFI)
  # ----------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ----------------------
  # Povinné – NIKDY neměnit po instalaci
  # ----------------------
  system.stateVersion = "25.11";
}