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
  # Tyto adresáře jsou součástí zálohy .application-data.
  # ------------------------------------------------------------

  home.activation.vscodiumDirectories = config.lib.dag.entryAfter ["linkGeneration"] ''
    mkdir -p "${vscodiumUserDataDir}/User"
    mkdir -p "${vscodiumExtensionsDir}"
  '';

  # ------------------------------------------------------------
  # Výchozí settings.json
  #
  # settings.json NENÍ spravován přes home.file.
  #
  # Musí zůstat skutečným zapisovatelným souborem, protože
  # VSCodium ho musí moci měnit.
  #
  # Pokud už existuje, jeho obsah se při rebuild nezmění.
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
  # Rozšíření jsou kopírována do .application-data/vscodium,
  # nikoliv symlinkována do /nix/store.
  #
  # Díky tomu je celý adresář skutečně zálohovatelný.
  # ------------------------------------------------------------

  home.activation.vscodiumExtensions = config.lib.dag.entryAfter ["vscodiumSettings"] ''
    EXTENSIONS="${vscodiumExtensionsDir}"

    # Odstranění starých symlinků a verzovaných adresářů
    # spravovaných předchozí konfigurací.
    rm -rf \
      "$EXTENSIONS/jnoortheen.nix-ide" \
      "$EXTENSIONS/jnoortheen.nix-ide-"* \
      "$EXTENSIONS/kamadorueda.alejandra" \
      "$EXTENSIONS/kamadorueda.alejandra-"* \
      "$EXTENSIONS/MS-CEINTL.vscode-language-pack-cs" \
      "$EXTENSIONS/ms-ceintl.vscode-language-pack-cs-"* \
      "$EXTENSIONS/ZooCodeOrganization.zoo-code" \
      "$EXTENSIONS/zoocodeorganization.zoo-code-"*

    # Nix IDE
    cp -a \
      "${pkgs.vscode-extensions.jnoortheen.nix-ide}/share/vscode/extensions/jnoortheen.nix-ide" \
      "$EXTENSIONS/"

    # Alejandra
    cp -a \
      "${pkgs.vscode-extensions.kamadorueda.alejandra}/share/vscode/extensions/kamadorueda.alejandra" \
      "$EXTENSIONS/"

    # Czech Language Pack
    cp -a \
      "${pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-cs}/share/vscode/extensions/MS-CEINTL.vscode-language-pack-cs" \
      "$EXTENSIONS/"

    # Zoo Code
    cp -a \
      "${zooCode}/share/vscode/extensions/ZooCodeOrganization.zoo-code" \
      "$EXTENSIONS/"

    # Tyto soubory jsou runtime metadata VSCodiumu.
    # VSCodium je po spuštění vytvoří znovu podle skutečného
    # obsahu extensions/.
    rm -f \
      "$EXTENSIONS/.obsolete" \
      "$EXTENSIONS/extensions.json"
  '';
}
