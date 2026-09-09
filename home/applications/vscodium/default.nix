{
  config,
  pkgs,
  unstable,
  ...
}: let
  vscodiumDataDir = "${config.home.homeDirectory}/.application-data/vscodium";

  vscodiumUserDataDir = "${vscodiumDataDir}/user-data";

  vscodiumExtensionsDir = "${vscodiumDataDir}/extensions";

  zooCode = pkgs.stdenvNoCC.mkDerivation {
    pname = "zoo-code";
    version = "3.82.0";

    src = pkgs.fetchurl {
      url =
        "https://open-vsx.org/api/ZooCodeOrganization/zoo-code/3.82.0/file/"
        + "ZooCodeOrganization.zoo-code-3.82.0.vsix";

      # Při prvním buildu Nix vypíše správný hash.
      hash = "sha256-68UrCEXwwLu+lAlvpgrtL0V+FjboSG6N0hOVPnUk9S4=";
    };

    nativeBuildInputs = [
      pkgs.unzip
    ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p "$out/share/vscode/extensions/ZooCodeOrganization.zoo-code"

      unzip -q "$src" -d "$TMPDIR/zoo-code"

      cp -r "$TMPDIR/zoo-code/extension/." \
        "$out/share/vscode/extensions/ZooCodeOrganization.zoo-code/"
    '';
  };

  vscodium = pkgs.symlinkJoin {
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
in {
  # ------------------------------------------------------------
  # VSCodium + Nix nástroje
  # ------------------------------------------------------------

  home.packages = [
    vscodium
    pkgs.nil
    pkgs.alejandra
  ];

  # ------------------------------------------------------------
  # Adresáře VSCodiumu
  #
  # Veškerá důležitá uživatelská data:
  #
  # ~/.application-data/vscodium/
  # ├── user-data/
  # └── extensions/
  #
  # ------------------------------------------------------------

  home.activation.vscodiumDirectories = config.lib.dag.entryAfter ["linkGeneration"] ''
    mkdir -p "${vscodiumUserDataDir}/User"
    mkdir -p "${vscodiumExtensionsDir}"
  '';

  # ------------------------------------------------------------
  # Výchozí settings.json
  #
  # Soubor není spravován pomocí home.file, protože VSCodium
  # ho musí mít možnost normálně zapisovat.
  #
  # Pokud už settings.json existuje, jeho obsah se nemění.
  # ------------------------------------------------------------

  home.activation.vscodiumSettings = config.lib.dag.entryAfter ["vscodiumDirectories"] ''
          SETTINGS="${vscodiumUserDataDir}/User/settings.json"

          # Pokud zde zůstal starý Home Manager symlink,
          # odstraníme ho, aby vznikl skutečný zapisovatelný soubor.
          if [ -L "$SETTINGS" ]; then
            rm -f "$SETTINGS"
          fi

          # Výchozí nastavení vytvoříme pouze při první instalaci.
          if [ ! -e "$SETTINGS" ]; then
            cat > "$SETTINGS" <<'EOF'
    {
      "editor.insertSpaces": true,
      "editor.tabSize": 2,
      "editor.formatOnSave": true,

      "files.autoSave": "afterDelay",
      "files.autoSaveDelay": 1000,

      "workbench.startupEditor": "none",

      "nix.enableLanguageServer": true,
      "nix.serverPath": "nil",
      "nix.formatterPath": "alejandra",

      "[nix]": {
        "editor.defaultFormatter": "kamadorueda.alejandra",
        "editor.formatOnSave": true,
        "editor.tabSize": 2,
        "editor.insertSpaces": true
      }
    }
    EOF
          fi
  '';

  # ------------------------------------------------------------
  # Rozšíření
  #
  # Rozšíření jsou deklarativní a mohou zůstat jako symlinky
  # do /nix/store.
  #
  # ------------------------------------------------------------

  home.file = {
    ".application-data/vscodium/extensions/jnoortheen.nix-ide".source = "${pkgs.vscode-extensions.jnoortheen.nix-ide}/share/vscode/extensions/jnoortheen.nix-ide";

    ".application-data/vscodium/extensions/kamadorueda.alejandra".source = "${pkgs.vscode-extensions.kamadorueda.alejandra}/share/vscode/extensions/kamadorueda.alejandra";

    ".application-data/vscodium/extensions/MS-CEINTL.vscode-language-pack-cs".source = "${pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-cs}/share/vscode/extensions/MS-CEINTL.vscode-language-pack-cs";

    ".application-data/vscodium/extensions/ZooCodeOrganization.zoo-code".source = "${zooCode}/share/vscode/extensions/ZooCodeOrganization.zoo-code";
  };
}
