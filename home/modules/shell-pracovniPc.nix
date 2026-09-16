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
    # Media
    # ----------------------------------------------------------

    jellyfin-media-player

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
  # FISH
  # ============================================================

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "eza -lah";
      cat = "bat";
      cd = "z";

      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#pracovniPc";
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