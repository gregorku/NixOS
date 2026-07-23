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
    package = pkgs.vscodium;

    mutableExtensionsDir = true;

    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
      ms-python.python
      ms-vscode.cpptools
      yzhang.markdown-all-in-one
    ];

    userSettings = {
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "editor.tabSize" = 2;
      "files.autoSave" = "afterDelay";

      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings.nil.formatting.command" = [ "nixfmt" ];
    };
  };
}
