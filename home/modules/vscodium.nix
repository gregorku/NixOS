```nix
{
  config,
  pkgs,
  unstable,
  ...
}:

{
  # ------------------------------------------------------------
  # VSCodium – všechna uživatelská data pod
  # ~/.application-data/vscodium
  # ------------------------------------------------------------

  my.applicationData = {
    enable = true;
    name = "vscodium";

    configDir = "VSCodium";
    dataDir = "VSCodium";
    cacheDir = "VSCodium";
  };

  # ------------------------------------------------------------
  # Nástroje používané VSCodium / Nix IDE
  # ------------------------------------------------------------

  home.packages = with pkgs; [
    nil
    alejandra
  ];

  # ------------------------------------------------------------
  # VSCodium
  # ------------------------------------------------------------

  programs.vscodium = {
    enable = true;

    # Zachováme tvoji současnou variantu z unstable.
    package = unstable.vscodium-fhs;

    profiles.default = {
      # Automatická instalace rozšíření.
      extensions = with pkgs.vscode-extensions; [
        # AI coding agent – pokračování Roo Code
        # Zoo Code
        #zoocodeorganization.zoo-code

        # Čeština
        ms-ceintl.vscode-language-pack-cs

        # Nix language server / syntax / diagnostika
        jnoortheen.nix-ide

        # Nix formatter
        kamadorueda.alejandra
      ];

      # ----------------------------------------------------------
      # VSCodium – obecné nastavení
      # ----------------------------------------------------------

      userSettings = {
        # Nepoužívat automatické formátování podle detekovaného
        # odsazení, ale používat nastavení editoru.
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;

        # Automatické formátování při uložení.
        "editor.formatOnSave" = true;

        # Automatické ukládání.
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;

        # Po spuštění neotevírat poslední editorovou stránku.
        "workbench.startupEditor" = "none";

        # --------------------------------------------------------
        # Nix
        # --------------------------------------------------------

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        # Alejandra jako formatter Nix souborů.
        "nix.formatterPath" = "alejandra";

        # --------------------------------------------------------
        # Nix – přesnější nastavení editoru
        # --------------------------------------------------------

        "[nix]" = {
          "editor.defaultFormatter" = "kamadorueda.alejandra";
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
        };
      };

      # ----------------------------------------------------------
      # Kontrola aktualizací VSCodium
      # ----------------------------------------------------------

      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;
    };
  };
}
```
