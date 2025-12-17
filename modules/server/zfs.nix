{
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs.autoScrub.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
