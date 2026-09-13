{
  config,
  pkgs,
  lib,
  ...
}: {
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
}
