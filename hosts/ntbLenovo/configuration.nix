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
  i18n.defaultLocale = "cs_CZ.UTF-8";
  time.timeZone = "Europe/Prague";
  console.keyMap = "cz";

  # ----------------------
  # 🐟 Fish shell
  # ----------------------
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Starship init je v NixOS dělán automaticky přes programs.starship.enableFishIntegration
      alias ll="ls -lah"
      alias rebuild="sudo nixos-rebuild switch"
    '';
  };

  # ----------------------
  # ⭐ Starship
  # ----------------------
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$username@$hostname $directory $git_branch $git_status\n$character";
      
      character = {
        success_symbol = "[➜](green)";
        error_symbol = "[✗](red)";
      };

      directory = {
        style = "blue";
        truncation_length = 3;
      };

      git_branch = {
        symbol = "🌱 ";
        style = "yellow";
      };

      git_status.style = "red";

      username = {
        style_user = "green";
        show_always = true;
      };

      hostname.style = "bold green";
    };
  };

  # ----------------------
  # 🐱 Kitty Terminal
  # ----------------------
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.9";
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
      copy_on_select = "yes";
      scrollback_lines = 10000;
    };
    keybindings = {
      "ctrl+alt+enter" = "launch --location=hsplit";
      "ctrl+alt+v" = "launch --location=vsplit";
      "ctrl+alt+h" = "neighboring_window left";
      "ctrl+alt+l" = "neighboring_window right";
      "ctrl+alt+k" = "neighboring_window up";
      "ctrl+alt+j" = "neighboring_window down";
    };
  };

  # Ostatní nastavení...
  boot.kernelParams = [ "pci=nocrs" ];
  services.libinput.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.11";
}