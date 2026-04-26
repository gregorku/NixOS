{ config, pkgs, ... }:

{
  # ----------------------
  # ZFS podpora
  # ----------------------
  boot.supportedFilesystems = [ "zfs" ];

  # CLI nástroje
  environment.systemPackages = with pkgs; [
    zfs
  ];

  # ----------------------
  # ZFS služby
  # ----------------------

  # kontrola integrity (scrub)
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  # TRIM pro SSD
  services.zfs.trim = {
    enable = true;
    interval = "weekly";
  };

  # snapshoty
  services.zfs.autoSnapshot = {
    enable = true;

    frequent = 4;   # ~ každých 15 min
    hourly   = 24;
    daily    = 7;
    weekly   = 4;
    monthly  = 3;
  };

  # ----------------------
  # Doporučené systémové nastavení
  # ----------------------

  # ZFS cache (ARC) se stará o paměť lépe než swap-heavy systémy
  boot.kernel.sysctl."vm.swappiness" = 10;

  # ----------------------
  # Bezpečné defaulty (doporučeno)
  # ----------------------

  # automatický import poolů při bootu
  boot.zfs.forceImportRoot = false;
}