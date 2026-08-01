{ config, pkgs, unstable, ... }:

{
  imports = [
    ./common.nix

    # Aplikace
    ./applications/jellyfin
  ];

  programs.librewolf = {
    enable = true;
    languagePacks = [ "cs" ];
    settings = {
      "intl.locale.requested" = "cs";
      "intl.multilingual.enabled" = false;
      "privacy.resistFingerprinting.spoofLocale" = false;

      # Firefox Standard místo Strict
      "browser.contentblocking.category" = "standard";
    };
  };

  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;

      settings = {
        # Obnoví předchozí relaci
        "browser.startup.page" = 3;

        # Nemazat historii ani relaci při ukončení
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.sessions" = false;
      };
    };
  };

  programs.vscode = {
    enable = true;

    # Použijeme připravený FHS balíček
    package = unstable.vscodium-fhs;

    extensions = with pkgs.vscode-extensions; [
      continue.continue
    ];
  };
}
