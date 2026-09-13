{
  config,
  pkgs,
  lib,
  ...
}: {
  # ============================================================
  # UŽIVATELSKÉ BALÍČKY
  # ============================================================

  home.packages = with pkgs; [
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
    # Nix vývoj
    # ----------------------------------------------------------

    nixd
    nixfmt

    # ----------------------------------------------------------
    # Python
    #
    # Verze 0.3.33 nefunguje
    # ----------------------------------------------------------

    (python3.withPackages (
      ps:
        with ps; [
          pandas
          openpyxl
        ]
    ))
  ];

  # ============================================================
  # PROSTŘEDÍ
  # ============================================================

  home.sessionVariables = {
    EDITOR = "nano";
    SAL_USE_VCLPLUGIN = "kf6";
  };

  # ============================================================
  # GTK
  # ============================================================

  gtk = {
    enable = true;

    colorScheme = "dark";

    theme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze-Dark";
    };

    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze-dark";
    };

    gtk2.enable = true;
    gtk3.enable = true;
    gtk4.enable = true;
  };

  # ============================================================
  # KITTY
  # ============================================================

  programs.kitty = {
    enable = true;

    settings = {
      font_family = "FiraCode Nerd Font";
      font_size = 10;

      background_opacity = 0.92;
      window_padding_width = 10;

      confirm_os_window_close = 0;
      enable_audio_bell = false;
      copy_on_select = true;
      scrollback_lines = 10000;

      term = "xterm-256color";
      enable_kitty_keyboard_protocol = false;
    };

    extraConfig = ''
      map ctrl+alt+enter launch --location=hsplit
      map ctrl+alt+v launch --location=vsplit
    '';
  };

  # ============================================================
  # FISH
  # ============================================================

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "eza -lah";
      cat = "bat";
      cd = "z";

      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#ntbLenovo";
    };

    interactiveShellInit = ''
      if set -q SSH_CONNECTION
          set -gx TERM xterm-256color
      end

      ${pkgs.zoxide}/bin/zoxide init fish | source
      ${pkgs.fzf}/bin/fzf --fish | source

      set -g fish_greeting ""
    '';
  };

  # ============================================================
  # STARSHIP
  # ============================================================

  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      add_newline = false;

      format = "$username$hostname $directory $git_branch $git_status $cmd_duration $character";

      username = {
        show_always = true;
        format = "$user";
        style_user = "#88C0D0";
      };

      hostname = {
        ssh_only = false;
        format = "@$hostname";
        style = "#81A1C1";
      };

      directory = {
        style = "#81A1C1";
        truncation_length = 3;
      };

      git_branch = {
        symbol = "🌱 ";
        style = "#EBCB8B";
      };

      git_status = {
        style = "#BF616A";
      };

      cmd_duration = {
        min_time = 500;
        format = "⏱ $duration ";
        style = "#D08770";
      };

      character = {
        success_symbol = "[➜](#A3BE8C)";
        error_symbol = "[✗](#BF616A)";
      };
    };
  };
}
