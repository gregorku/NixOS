{
  config,
  pkgs,
  unstable,
  ...
}: let
  janDataDir = "${config.home.homeDirectory}/.application-data/jan";

  janConfigDir = "${janDataDir}/config";

  janCacheDir = "${janDataDir}/cache";

  jan = pkgs.symlinkJoin {
    name = "jan-custom";

    paths = [
      unstable.jan
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
  # Jan z nixpkgs unstable
  # ------------------------------------------------------------

  home.packages = [
    jan
  ];

  # ------------------------------------------------------------
  # Jan data
  #
  # Všechna uživatelská data Jan jsou soustředěna pod:
  #
  # ~/.application-data/jan/
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
  # Používá náš wrapper, nikoliv přímo unstable.jan.
  # Tím jsou stejné XDG cesty použity při spuštění z menu
  # i z terminálu.
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
