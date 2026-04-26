{ config, pkgs, ... }:

{
  # ZFS podpora
  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [
    zfs
  ];

  # ZFS služby
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  services.zfs.trim = {
    enable = true;
    interval = "weekly";
  };

  services.zfs.autoSnapshot = {
    enable = true;

    frequent = 4;
    hourly   = 24;
    daily    = 7;
    weekly   = 4;
    monthly  = 3;
  };
}