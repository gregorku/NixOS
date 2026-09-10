{
  config,
  pkgs,
  unstable,
  ...
}: let
  janDataDir = "${config.home.homeDirectory}/.application-data/jan";

  janConfigDir = "${janDataDir}/config";
  janDataHome = "${janDataDir}/data";
  janCacheDir = "${janDataDir}/cache";

  jan = pkgs.symlinkJoin {
    name = "jan-custom";
    paths = [unstable.jan];

    nativeBuildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram "$out/bin/Jan" \
        --set XDG_CONFIG_HOME "${janConfigDir}" \
        --set XDG_DATA_HOME "${janDataHome}" \
        --set XDG_CACHE_HOME "${janCacheDir}"
    '';
  };
in {
  home.packages = [
    jan
  ];
}
