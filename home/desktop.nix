{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

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
        # Obnoví předchozí relaci (otevřené panely a okna)
        "browser.startup.page" = 3;
        
        # Pojistka, aby se historie a relace nemazaly při zavření
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.sessions" = false;
      };
    };
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;           # nebo pkgs.vscodium-fhs

    # Pokud chceš nejnovější verzi:
    package = pkgs.vscodium.overrideAttrs (old: {
      src = pkgs.fetchurl {
        url = "https://github.com/VSCodium/vscodium/releases/download/1.100.0.24307/codium-1.100.0.24307-el8.x86_64.rpm"; # nahraď aktuální verzí
        hash = "sha256-..."; # musíš doplnit
      };
    });
    # Nebo jednodušší varianta – použít unstable:
    # package = pkgs.unstable.vscodium;
  };
}