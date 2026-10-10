{
  config,
  pkgs,
  unstable,
  ...
}: let
  cursorDataDir = "${config.home.homeDirectory}/.application-data/cursor";

  cursorUserDataDir = "${cursorDataDir}/user-data";
  cursorExtensionsDir = "${cursorDataDir}/extensions";
  cursorConfigDir = "${cursorDataDir}/config";
  cursorDataHome = "${cursorDataDir}/data";
  cursorCacheDir = "${cursorDataDir}/cache";

  cursor = pkgs.symlinkJoin {
    name = "cursor-custom";

    paths = [
      unstable.code-cursor
    ];

    nativeBuildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram "$out/bin/cursor" \
        --add-flags "--user-data-dir=${cursorUserDataDir}" \
        --add-flags "--extensions-dir=${cursorExtensionsDir}" \
        --set XDG_CONFIG_HOME "${cursorConfigDir}" \
        --set XDG_DATA_HOME "${cursorDataHome}" \
        --set XDG_CACHE_HOME "${cursorCacheDir}"
    '';
  };
in {
  home.packages = [
    cursor
  ];

  home.activation.cursorDirectories = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p \
      "${cursorUserDataDir}" \
      "${cursorExtensionsDir}" \
      "${cursorConfigDir}" \
      "${cursorDataHome}" \
      "${cursorCacheDir}"
  '';
}
