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
    package = pkgs.vscodium-bin;   # nebo pkgs.vscodium
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      # ... další rozšíření
    ];
    userSettings = {
      "editor.fontSize" = 14;
      "workbench.colorTheme" = "Default Dark+";
    };
  };
  # ... zbytek konfigurace
}
