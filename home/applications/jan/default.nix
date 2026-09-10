{
  config,
  pkgs,
  ...
}: let
  janRoot = "${config.home.homeDirectory}/.application-data/jan";

  janConfigDir = "${janRoot}/config";

  janDataDir = "${janRoot}/data";

  janCacheDir = "${janRoot}/cache";

  janApp = pkgs.appimageTools.wrapType2 {
    pname = "jan";
    version = "0.8.4";

    src = pkgs.fetchurl {
      url = "https://github.com/janhq/jan/releases/download/v0.8.4/Jan_0.8.4_amd64.AppImage";

      hash = pkgs.lib.fakeHash;
    };
  };

  jan = pkgs.symlinkJoin {
    name = "jan-custom";

    paths = [
      janApp
    ];

    nativeBuildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram "$out/bin/jan" \
        --set XDG_CONFIG_HOME "${janConfigDir}" \
        --set XDG_DATA_HOME "${janDataDir}" \
        --set XDG_CACHE_HOME "${janCacheDir}"
    '';
  };
in {
  # ------------------------------------------------------------
  # Jan
  # ------------------------------------------------------------

  home.packages = [
    jan
  ];

  # ------------------------------------------------------------
  # Jan data
  #
  # Všechna data Jan zůstávají pod:
  #
  # ~/.application-data/jan/
  #
  # XDG:
  #
  # config -> ~/.application-data/jan/config/
  # data   -> ~/.application-data/jan/data/
  # cache  -> ~/.application-data/jan/cache/
  #
  # ------------------------------------------------------------

  home.activation.janDirectories = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "${janConfigDir}"
    mkdir -p "${janDataDir}"
    mkdir -p "${janCacheDir}"
  '';

  # ------------------------------------------------------------
  # Desktop launcher
  #
  # Používá náš wrapper, takže Jan dostane stejné XDG
  # adresáře jako při spuštění z terminálu.
  # ------------------------------------------------------------

  xdg.desktopEntries.jan = {
    name = "Jan";
    genericName = "AI Assistant";
    comment = "Open-source AI assistant";

    exec = "${jan}/bin/jan %U";

    icon = "jan";
    terminal = false;

    categories = [
      "Utility"
      "Development"
    ];
  };
}
