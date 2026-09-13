{
  config,
  pkgs,
  lib,
  ...
}: {
  # ============================================================
  # KDE / PLASMA – NTB LENOVO
  #
  # Uživatelská konfigurace:
  #
  # - GTK / ikony / kurzor
  # - Kitty
  # - Fish + CLI
  # - Starship
  # - KDE vzhled
  #
  # Panel a menu se zde nepřepisují.
  # ============================================================

  # ============================================================
  # UŽIVATELSKÉ BALÍČKY
  # ============================================================

  home.packages = with pkgs; [
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

    # Verze 0.3.33 nefunguje
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

  # ============================================================
  # KDE VZHLED – BREEZE + NORD
  # ============================================================

  qt = {
    enable = true;

    kde.settings = {
      kdeglobals = {
        General = {
          ColorScheme = "GregorNordDark";
          AccentColor = "94,129,172";
        };

        KDE = {
          widgetStyle = "Breeze";
        };

        Icons = {
          Theme = "breeze-dark";
        };
      };

      kcminputrc = {
        Mouse = {
          cursorTheme = "breeze_cursors";
          cursorSize = 24;
        };
      };
    };
  };

  # ============================================================
  # VLASTNÍ NORD DARK COLOR SCHEME
  # ============================================================

  home.file.".local/share/color-schemes/GregorNordDark.colors".text = ''
    [ColorEffects:Disabled]
    Color=46,52,64
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=67,76,94
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Window]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=94,129,172
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=163,173,189
    ForegroundLink=129,161,193
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:View]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=94,129,172
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=163,173,189
    ForegroundLink=129,161,193
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=229,233,240
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Button]
    BackgroundAlternate=67,76,94
    BackgroundNormal=59,66,82
    DecorationFocus=94,129,172
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=163,173,189
    ForegroundLink=129,161,193
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Selection]
    BackgroundAlternate=94,129,172
    BackgroundNormal=94,129,172
    DecorationFocus=136,192,208
    DecorationHover=136,192,208
    ForegroundActive=236,239,244
    ForegroundInactive=229,233,240
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Tooltip]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=94,129,172
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=163,173,189
    ForegroundLink=129,161,193
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Complementary]
    BackgroundAlternate=67,76,94
    BackgroundNormal=46,52,64
    DecorationFocus=94,129,172
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=163,173,189
    ForegroundLink=129,161,193
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Header]
    BackgroundAlternate=67,76,94
    BackgroundNormal=59,66,82
    DecorationFocus=94,129,172
    DecorationHover=136,192,208
    ForegroundActive=136,192,208
    ForegroundInactive=163,173,189
    ForegroundLink=129,161,193
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Header][Inactive]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=129,161,193
    DecorationHover=136,192,208
    ForegroundActive=129,161,193
    ForegroundInactive=163,173,189
    ForegroundLink=129,161,193
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=216,222,233
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [General]
    ColorScheme=GregorNordDark
    Name=Gregor Nord Dark
    shadeSortColumn=true

    [KDE]
    contrast=4

    [WM]
    activeBackground=46,52,64,191
    activeBlend=236,239,244
    activeForeground=236,239,244
    inactiveBackground=46,52,64
    inactiveBlend=163,173,189
    inactiveForeground=163,173,189
  '';
}
