{
  config,
  pkgs,
  lib,
  ...
}: {
  # ============================================================
  # KDE / PLASMA 6.6.6 – NTB LENOVO
  #
  # Uživatelská konfigurace:
  #
  # - GTK / ikony / kurzor
  # - Kitty
  # - Fish + CLI
  # - Starship
  # - KDE vzhled
  #
  # ZÁMĚRNĚ:
  # - žádný Klassy
  # - žádné externí Plasma plasmoidy
  # - žádný zásah do panelu
  # - žádný zásah do menu
  #
  # Základ vzhledu:
  # - Breeze Dark
  # - Gregor Nord Dark
  # - Nord Blue accent
  #
  # Panel a menu zůstávají beze změny.
  # ============================================================

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
  # GTK – BREEZE DARK
  #
  # Catppuccin z původní systémové konfigurace odstraňujeme.
  #
  # GTK aplikace:
  #   GTK2 → Breeze-Dark
  #   GTK3 → Breeze-Dark
  #   GTK4 → Breeze-Dark
  #
  # Ikony:
  #   Breeze Dark
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
    shellIntegration.enableFishIntegration = true;

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
  #
  # Nepoužíváme Klassy.
  #
  # Záměr:
  #
  #   Application Style = Breeze
  #   Window Decoration = Breeze
  #   Plasma Style      = výchozí KDE/Breeze
  #   Color Scheme      = Gregor Nord Dark
  #   Accent            = Nord Blue #5E81AC
  #   Icons             = Breeze Dark
  #   Cursor             = Breeze
  #
  # Panel a menu NEPŘEPISUJEME.
  #
  # qt.kde.settings používá kwriteconfig6 a mění pouze
  # uvedené položky.
  # ============================================================

  qt = {
    enable = true;

    kde.settings = {
      # ----------------------------------------------------------
      # KDE GLOBALS
      # ----------------------------------------------------------

      kdeglobals = {
        General = {
          ColorScheme = "GregorNordDark";

          # Nord Blue
          AccentColor = "94,129,172";
        };

        KDE = {
          # Standardní KDE widget style.
          # Necháváme bez externího stylu typu Klassy.
          widgetStyle = "Breeze";
        };

        Icons = {
          Theme = "breeze-dark";
        };
      };

      # ----------------------------------------------------------
      # PLASMA
      #
      # Plasma Style záměrně nenastavujeme natvrdo.
      #
      # Tím necháváme KDE použít standardní Plasma/Breeze theme
      # a vyhneme se problémům s externími Plasma tématy.
      # ----------------------------------------------------------

      # ----------------------------------------------------------
      # KURZOR
      # ----------------------------------------------------------

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
  #
  # Nord palette:
  #
  # Polar Night:
  #   #2E3440
  #   #3B4252
  #   #434C5E
  #   #4C566A
  #
  # Snow Storm:
  #   #D8DEE9
  #   #E5E9F0
  #   #ECEFF4
  #
  # Frost:
  #   #8FBCBB
  #   #88C0D0
  #   #81A1C1
  #   #5E81AC
  #
  # Aurora:
  #   #BF616A
  #   #D08770
  #   #EBCB8B
  #   #A3BE8C
  #   #B48EAD
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
    DecorationFocus=94,129,172
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

  # ============================================================
  # KDE / PLASMA – ZÁMĚRNĚ MINIMÁLNÍ
  #
  # Tento modul:
  #
  #   - nepřidává desktopové widgety
  #   - nemanipuluje s existujícím panelem
  #   - nemanipuluje s menu
  #   - nepřidává Catppuccin plasmoidy
  #   - nepřidává Bix/Flex widgety
  #   - nepoužívá Klassy
  #
  # Výsledkem je:
  #
  #   - Breeze Dark
  #   - Gregor Nord Dark
  #   - Nord Blue accent
  #   - Breeze icons
  #   - Breeze cursor
  #
  # ============================================================
}
