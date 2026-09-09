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

      # Záměrně fakeHash – Nix nám při prvním buildu vypíše správný hash.
      hash = pkgs.lib.fakeHash;
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
  home.packages = [
    vscodium
    pkgs.nil
    pkgs.alejandra
  ];

  home.activation.vscodiumDirectories = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "${vscodiumUserDataDir}"
    mkdir -p "${vscodiumExtensionsDir}"
  '';

  home.file.".application-data/vscodium/user-data/User/settings.json".text = builtins.toJSON {
    "editor.insertSpaces" = true;
    "editor.tabSize" = 2;
    "editor.formatOnSave" = true;

    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;

    "workbench.startupEditor" = "none";

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

  home.file = {
    ".application-data/vscodium/extensions/jnoortheen.nix-ide".source = "${pkgs.vscode-extensions.jnoortheen.nix-ide}/share/vscode/extensions/jnoortheen.nix-ide";

    ".application-data/vscodium/extensions/kamadorueda.alejandra".source = "${pkgs.vscode-extensions.kamadorueda.alejandra}/share/vscode/extensions/kamadorueda.alejandra";

    ".application-data/vscodium/extensions/MS-CEINTL.vscode-language-pack-cs".source = "${pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-cs}/share/vscode/extensions/MS-CEINTL.vscode-language-pack-cs";

    ".application-data/vscodium/extensions/ZooCodeOrganization.zoo-code".source = "${zooCode}/share/vscode/extensions/ZooCodeOrganization.zoo-code";
  };
}
