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

  # Podpis aktuální sady rozšíření. Mění se pouze tehdy, když se
  # skutečně změní obsah některého z derivací níže (nová verze,
  # jiný hash apod.) - ne při každém home-manager rebuildu.
  vscodiumExtensionsSignature = builtins.hashString "sha256" (builtins.concatStringsSep "\n" [
    "${pkgs.vscode-extensions.jnoortheen.nix-ide}"
    "${pkgs.vscode-extensions.kamadorueda.alejandra}"
    "${pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-cs}"
    "${pkgs.vscode-extensions.redhat.vscode-yaml}"
    "${zooCode}"
  ]);

  # --------------------------------------------------------
  # extensions.json generovaný přímo v Nixu.
  #
  # Dřívější přístup (smazat extensions.json a nechat VSCodium,
  # aby si rozšíření samo "objevilo" při skenování adresáře) se
  # ukázal jako nespolehlivý - v praxi se stalo, že jedno z
  # rozšíření (redhat.vscode-yaml) VSCodium při pasivním skenu
  # z neznámého důvodu vynechalo, přestože bylo na disku validně
  # zkopírované. Proto místo spoléhání na autodetekci zapisujeme
  # manifest s korektními záznamy rovnou.
  # --------------------------------------------------------

  mkExtensionEntry = {
    id,
    version,
    relativeLocation,
  }: {
    identifier.id = id;
    version = version;
    location = {
      "$mid" = 1;
      path = "${vscodiumExtensionsDir}/${relativeLocation}";
      scheme = "file";
    };
    relativeLocation = relativeLocation;
    metadata = {
      installedTimestamp = 0;
      source = "gallery";
      isPreReleaseVersion = false;
    };
  };

  vscodiumExtensionsManifest = pkgs.writeText "vscodium-extensions.json" (builtins.toJSON (map mkExtensionEntry [
    {
      id = "jnoortheen.nix-ide";
      version = pkgs.vscode-extensions.jnoortheen.nix-ide.version;
      relativeLocation = "jnoortheen.nix-ide";
    }
    {
      id = "kamadorueda.alejandra";
      version = pkgs.vscode-extensions.kamadorueda.alejandra.version;
      relativeLocation = "kamadorueda.alejandra";
    }
    {
      id = "ms-ceintl.vscode-language-pack-cs";
      version = pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-cs.version;
      relativeLocation = "MS-CEINTL.vscode-language-pack-cs";
    }
    {
      id = "redhat.vscode-yaml";
      version = pkgs.vscode-extensions.redhat.vscode-yaml.version;
      relativeLocation = "redhat.vscode-yaml";
    }
    {
      id = "zoocodeorganization.zoo-code";
      version = zooCode.version;
      relativeLocation = "ZooCodeOrganization.zoo-code";
    }
  ]));

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
    SIGNATURE_FILE="$EXTENSIONS/.nix-signature"
    NEW_SIGNATURE="${vscodiumExtensionsSignature}"

    # --------------------------------------------------------
    # Pokud se sada rozšíření od minula nezměnila A všechny
    # adresáře rozšíření skutečně existují, nic neděláme.
    #
    # Bez kontroly signature by se extensions.json a .obsolete
    # mazaly při KAŽDÉM home-manager rebuildu, i když se rozšíření
    # vůbec nezměnila. VSCodium pak při dalším startu bere všechna
    # rozšíření jako "nově objevená" a vyžaduje reload okna -
    # u jazykového balíčku se to projeví jako pád zpět do
    # angličtiny, dokud reload neproběhne.
    #
    # Bez kontroly existence adresářů by ale ruční odinstalování
    # rozšíření přes GUI VSCodia (nebo smazání adresáře) zůstalo
    # nepovšimnuto, dokud by se nezměnila i verze některé Nix
    # derivace - do té doby by se dané rozšíření nikdy neobnovilo.
    # --------------------------------------------------------

    NEEDS_SYNC=false

    if [ ! -f "$SIGNATURE_FILE" ] || [ "$(cat "$SIGNATURE_FILE")" != "$NEW_SIGNATURE" ]; then
      NEEDS_SYNC=true
    fi

    for EXT_DIR in \
      "jnoortheen.nix-ide" \
      "kamadorueda.alejandra" \
      "MS-CEINTL.vscode-language-pack-cs" \
      "redhat.vscode-yaml" \
      "ZooCodeOrganization.zoo-code"
    do
      if [ ! -d "$EXTENSIONS/$EXT_DIR" ]; then
        NEEDS_SYNC=true
      fi
    done

    if [ "$NEEDS_SYNC" = false ]; then
      echo "VSCodium rozšíření beze změny, přeskakuji synchronizaci." >&2
    else

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
      "$EXTENSIONS/redhat.vscode-yaml" \
      "$EXTENSIONS/redhat.vscode-yaml-"* \
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
    # Red Hat YAML
    # --------------------------------------------------------

    cp -a \
      "${pkgs.vscode-extensions.redhat.vscode-yaml}/share/vscode/extensions/redhat.vscode-yaml" \
      "$EXTENSIONS/"

    # --------------------------------------------------------
    # Zoo Code
    # --------------------------------------------------------

    cp -a \
      "${zooCode}/share/vscode/extensions/ZooCodeOrganization.zoo-code" \
      "$EXTENSIONS/"

    # --------------------------------------------------------
    # PlatformIO IDE
    # --------------------------------------------------------

    cp -a \
      "${platformioIde}/share/vscode/extensions/platformio.platformio-ide" \
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
    # Místo mazání extensions.json (a spoléhání na to, že ho
    # VSCodium při startu samo správně znovu vytvoří skenováním
    # adresáře - což se ukázalo jako nespolehlivé) zapisujeme
    # manifest vygenerovaný přímo v Nixu, s korektními záznamy
    # pro všechna spravovaná rozšíření.
    # --------------------------------------------------------

    rm -f "$EXTENSIONS/.obsolete"

    cp -f "${vscodiumExtensionsManifest}" "$EXTENSIONS/extensions.json"
    chmod u+rw "$EXTENSIONS/extensions.json"

    echo "$NEW_SIGNATURE" > "$SIGNATURE_FILE"

    fi
  '';
}
