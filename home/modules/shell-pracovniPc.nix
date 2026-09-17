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
  #
  # Původní konfigurace pracovniPc:
  #
  #   programs.fish = {
  #     enable = true;
  #     interactiveShellInit = ''
  #       set -gx STARSHIP_CONFIG /etc/starship.toml
  #       ...
  #     '';
  #   };
  #
  # V Home Manageru jsou aliasy převedené do shellAliases
  # a Starship spravuje Home Manager přímo.
  # ============================================================

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "eza -lah";
      cat = "bat";
      cd = "z";

      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#pracovniPc";
      #alias rebuild="sudo nixos-rebuild switch --flake /etc/nixos#pracovniPc"
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
  #
  # Původní /etc/starship.toml z configuration.nix
  # převedený přímo do Home Manageru.
  #
  # Tím už není potřeba:
  #
  #   set -gx STARSHIP_CONFIG /etc/starship.toml
  #
  # ani systémový:
  #
  #   environment.etc."starship.toml"
  #
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
        style_user = "#a6e3a1";
      };

      hostname = {
        ssh_only = false;
        format = "@$hostname";
        style = "#89b4fa";
      };

      directory = {
        style = "#89b4fa";
        truncation_length = 3;
      };

      git_branch = {
        symbol = "🌱 ";
        style = "#f9e2af";
      };

      git_status = {
        style = "#f38ba8";
      };

      cmd_duration = {
        min_time = 500;
        format = "⏱ $duration ";
        style = "#fab387";
      };

      character = {
        success_symbol = "[➜](#a6e3a1)";
        error_symbol = "[✗](#f38ba8)";
      };
    };
  };
}