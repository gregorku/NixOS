{
  config,
  pkgs,
  unstable,
  ...
}:

let
  vscodiumDataDir =
    "${config.home.homeDirectory}/.application-data/vscodium";

  vscodiumUserDataDir =
    "${vscodiumDataDir}/user-data";

  vscodiumExtensionsDir =
    "${vscodiumDataDir}/extensions";

  vscodium =
    pkgs.symlinkJoin {
      name = "vscodium-custom";

      paths = [
        unstable.vscodium-fhs
      ];

      nativeBuildInputs = [
        pkgs.makeWrapper
      ];

      postBuild = ''
        wrapProgram "$out/bin/codium" \
          --add-flags "--user-data-dir ${vscodiumUserDataDir}" \
          --add-flags "--extensions-dir ${vscodiumExtensionsDir}"
      '';
    };
in
{
  # ------------------------------------------------------------
  # VSCodium
  #
  # Všechna uživatelská data:
  #
  # ~/.application-data/vscodium/
  # ├── user-data/
  # └── extensions/
  #
  # ------------------------------------------------------------

  home.packages = [
    vscodium

    # Nix nástroje používané VSCodium
    pkgs.nil
    pkgs.alejandra
  ];

  # ------------------------------------------------------------
  # Vytvoření datových adresářů
  # ------------------------------------------------------------

  home.activation.vscodiumDirectories =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${vscodiumUserDataDir}"
      mkdir -p "${vscodiumExtensionsDir}"
    '';

  # ------------------------------------------------------------
  # VSCodium nastavení
  # ------------------------------------------------------------

  home.file.".application-data/vscodium/user-data/User/settings.json".text =
    builtins.toJSON {
      "editor.insertSpaces" = true;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;

      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;

      "workbench.startupEditor" = "none";

      # Nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.formatterPath" = "alejandra";

      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
      };
    };

  # ------------------------------------------------------------
  # Deklarativně instalovaná rozšíření
  # ------------------------------------------------------------

  home.file = {
    ".application-data/vscodium/extensions/jnoortheen.nix-ide".source =
      "${pkgs.vscode-extensions.jnoortheen.nix-ide}/share/vscode/extensions/jnoortheen.nix-ide";

    ".application-data/vscodium/extensions/kamadorueda.alejandra".source =
      "${pkgs.vscode-extensions.kamadorueda.alejandra}/share/vscode/extensions/kamadorueda.alejandra";

    ".application-data/vscodium/extensions/MS-CEINTL.vscode-language-pack-cs".source =
      "${pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-cs}/share/vscode/extensions/MS-CEINTL.vscode-language-pack-cs";
  };
}
