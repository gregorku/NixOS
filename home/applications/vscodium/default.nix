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
        --add-flags "--user-data-dir=${vscodiumUserDataDir}" \
        --add-flags "--extensions-dir=${vscodiumExtensionsDir}"
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
  # ~/.application-data/vscodium/
  # ├── user-data/
  # └── extensions/
  #
  # Celý adresář je součástí zálohy .application-data.
  # ------------------------------------------------------------

  home.activation.vscodiumDirectories = config.lib.dag.entryAfter ["linkGeneration"] ''
    mkdir -p "${vscodiumUserDataDir}/User"
    mkdir -p "${vscodiumExtensionsDir}"
  '';

  # ------------------------------------------------------------
  # Výchozí settings.json
  #
  # settings.json není spravován přes home.file.
  # Musí zůstat skutečným zapisovatelným souborem.
  # ------------------------------------------------------------

  home.activation.vscodiumSettings = config.lib.dag.entryAfter ["vscodiumDirectories"] ''
          SETTINGS="${vscodiumUserDataDir}/User/settings.json"

          # Pokud zde zůstal starý Home Manager symlink,
          # odstraníme ho.
          if [ -L "$SETTINGS" ]; then
            rm -f "$SETTINGS"
          fi

          # Výchozí konfiguraci vytvoříme pouze při první instalaci.
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
  # VSCodium extensions
  #
  # Rozšíření jsou skutečně kopírována do
  # ~/.application-data/vscodium/extensions.
  #
  # Důležité:
  # cp -a zachovává read-only režimy z /nix/store.
  # Proto po každém kopírování nastavíme lokální soubory
  # jako zapisovatelné.
  # ------------------------------------------------------------

  home.activation.vscodiumExtensions = config.lib.dag.entryAfter ["vscodiumSettings"] ''
    EXTENSIONS="${vscodiumExtensionsDir}"

    # --------------------------------------------------------
    # OPRAVA PRÁV EXISTUJÍCÍCH ROZŠÍŘENÍ
    #
    # Rozšíření byla dříve kopírována pomocí cp -a z Nix store.
    # Ten obsahuje read-only soubory/adresáře.
    #
    # Před rm -rf proto musíme lokální kopie zpřístupnit
    # pro zápis.
    # --------------------------------------------------------

    if [ -d "$EXTENSIONS" ]; then
      chmod -R u+rwX "$EXTENSIONS"
    fi

    # --------------------------------------------------------
    # Odstranění starých verzí/symlinků
    # --------------------------------------------------------

    rm -rf \
      "$EXTENSIONS/jnoortheen.nix-ide" \
      "$EXTENSIONS/jnoortheen.nix-ide-"* \
      "$EXTENSIONS/kamadorueda.alejandra" \
      "$EXTENSIONS/kamadorueda.alejandra-"* \
      "$EXTENSIONS/MS-CEINTL.vscode-language-pack-cs" \
      "$EXTENSIONS/ms-ceintl.vscode-language-pack-cs-"* \
      "$EXTENSIONS/ZooCodeOrganization.zoo-code" \
      "$EXTENSIONS/zoocodeorganization.zoo-code-"*

    # --------------------------------------------------------
    # Nix IDE
    # --------------------------------------------------------

    cp -a \
      "${pkgs.vscode-extensions.jnoortheen.nix-ide}/share/vscode/extensions/jnoortheen.nix-ide" \
      "$EXTENSIONS/"

    # --------------------------------------------------------
    # Alejandra
    # --------------------------------------------------------

    cp -a \
      "${pkgs.vscode-extensions.kamadorueda.alejandra}/share/vscode/extensions/kamadorueda.alejandra" \
      "$EXTENSIONS/"

    # --------------------------------------------------------
    # Czech Language Pack
    # --------------------------------------------------------

    cp -a \
      "${pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-cs}/share/vscode/extensions/MS-CEINTL.vscode-language-pack-cs" \
      "$EXTENSIONS/"

    # --------------------------------------------------------
    # Zoo Code
    # --------------------------------------------------------

    cp -a \
      "${zooCode}/share/vscode/extensions/ZooCodeOrganization.zoo-code" \
      "$EXTENSIONS/"

    # --------------------------------------------------------
    # DŮLEŽITÉ:
    # cp -a zachoval read-only režimy z /nix/store.
    #
    # Uděláme z lokálních kopií normální zapisovatelné soubory
    # a adresáře.
    # --------------------------------------------------------

    chmod -R u+rwX "$EXTENSIONS"

    # --------------------------------------------------------
    # Runtime metadata VSCodiumu
    #
    # VSCodium je při spuštění vytvoří znovu podle skutečného
    # obsahu extensions/.
    # --------------------------------------------------------

    rm -f \
      "$EXTENSIONS/.obsolete" \
      "$EXTENSIONS/extensions.json"
  '';
}
