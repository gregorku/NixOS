{
  imports = [
    ./launcher.nix
  ];

  my.applicationData = {
    enable = true;

    name = "jellyfin";

    configDir = "jellyfin-desktop";

    dataDir = "jellyfin-desktop";

    cacheDir = "jellyfin-desktop";
  };
}