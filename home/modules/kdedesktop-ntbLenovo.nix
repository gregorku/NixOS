{
  config,
  pkgs,
  lib,
  ...
}: {
  # ============================================================
  # NORD + KLASSY + PAPIRUS DARK
  #
  # Vzhled KDE Plasma:
  #   - Plasma style       → Klassy Dark
  #   - Application style  → Klassy
  #   - Window decoration  → Klassy
  #   - Color scheme       → Gregor Nord Dark
  #   - Icons              → Papirus Dark
  #   - Cursor             → Breeze
  #
  # Rozložení panelu, menu a plochy záměrně neměníme.
  # ============================================================

  # ============================================================
  # VZHLED – BALÍČKY
  # ============================================================

  home.packages = with pkgs; [
    klassy
    papirus-icon-theme
  ];

  # ============================================================
  # GTK
  # ============================================================

  gtk = {
    enable = true;

    colorScheme = "dark";

    # Zatím ponecháváme Breeze GTK jako stabilní základ.
    # Nord vzhled řeší KDE Color Scheme níže.
    theme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze-Dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    gtk2.enable = true;
    gtk3.enable = true;
    gtk4.enable = true;
  };

  # ============================================================
  # QT / KDE
  # ============================================================

  qt = {
    enable = true;

    platformTheme.name = "kde";

    kde.settings = {
      # ----------------------------------------------------------
      # KDE GLOBALS
      # ----------------------------------------------------------
      kdeglobals = {
        General = {
          ColorScheme = "GregorNordDark";
          AccentColor = "94,129,172";
        };

        KDE = {
          widgetStyle = "klassy";
        };

        Icons = {
          Theme = "Papirus-Dark";
        };
      };

      # ----------------------------------------------------------
      # WINDOW DECORATION – KLASSY
      # ----------------------------------------------------------
      kwinrc = {
        "org.kde.kdecoration3" = {
          library = "org.kde.klassy";
        };
      };

      # ----------------------------------------------------------
      # PLASMA STYLE – KLASSY DARK
      # ----------------------------------------------------------
      plasmarc = {
        Theme = {
          name = "klassy-dark";
        };
      };

      # ----------------------------------------------------------
      # CURSOR
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
  # NORD COLOR SCHEME
  # ============================================================

  home.file.".local/share/color-schemes/GregorNordDark.colors".text = ''
    [ColorEffects:Disabled]
    Color=117,117,117
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0
    ContrastEffect=0
    IntensityAmount=0
    IntensityEffect=0

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=46,52,64
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0
    ContrastEffect=0
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=59,66,82
    BackgroundNormal=67,76,94
    DecorationFocus=136,192,208
    DecorationHover=129,161,193
    ForegroundActive=236,239,244
    ForegroundInactive=216,222,233
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Complementary]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=136,192,208
    DecorationHover=129,161,193
    ForegroundActive=236,239,244
    ForegroundInactive=216,222,233
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Header]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=136,192,208
    DecorationHover=129,161,193
    ForegroundActive=236,239,244
    ForegroundInactive=216,222,233
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Selection]
    BackgroundAlternate=94,129,172
    BackgroundNormal=94,129,172
    DecorationFocus=136,192,208
    DecorationHover=129,161,193
    ForegroundActive=236,239,244
    ForegroundInactive=216,222,233
    ForegroundLink=236,239,244
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=236,239,244

    [Colors:Tooltip]
    BackgroundAlternate=67,76,94
    BackgroundNormal=59,66,82
    DecorationFocus=136,192,208
    DecorationHover=129,161,193
    ForegroundActive=236,239,244
    ForegroundInactive=216,222,233
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:View]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=136,192,208
    DecorationHover=129,161,193
    ForegroundActive=236,239,244
    ForegroundInactive=216,222,233
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=216,222,233
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [Colors:Window]
    BackgroundAlternate=59,66,82
    BackgroundNormal=46,52,64
    DecorationFocus=136,192,208
    DecorationHover=129,161,193
    ForegroundActive=236,239,244
    ForegroundInactive=216,222,233
    ForegroundLink=136,192,208
    ForegroundNegative=191,97,106
    ForegroundNeutral=235,203,139
    ForegroundNormal=236,239,244
    ForegroundPositive=163,190,140
    ForegroundVisited=180,142,173

    [General]
    ColorScheme=GregorNordDark
    Name=Gregor Nord Dark
    shadeSortColumn=true

    [WM]
    activeBackground=46,52,64
    activeBlend=136,192,208
    activeForeground=236,239,244
    inactiveBackground=59,66,82
    inactiveBlend=76,86,106
    inactiveForeground=216,222,233
  '';

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
}
