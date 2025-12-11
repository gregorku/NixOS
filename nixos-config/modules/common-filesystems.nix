{ config, pkgs, ... }:

{
  fileSystems."/" = {
    options = [
      "compress=zstd"
      "ssd"
      "noatime"
      "space_cache=v2"
      "discard=async"
    ];
  };

  fileSystems."/home".options = [
    "compress=zstd"
    "ssd"
    "noatime"
    "space_cache=v2"
    "discard=async"
  ];

  fileSystems."/var/log".options = [
    "compress=zstd"
    "ssd"
    "noatime"
    "space_cache=v2"
  ];

  fileSystems."/var/cache".options = [
    "compress=zstd"
    "ssd"
    "noatime"
    "space_cache=v2"
  ];

  fileSystems."/.snapshots".options = [
    "compress=zstd"
    "ssd"
    "noatime"
    "space_cache=v2"
  ];

  services.fstrim.enable = true;
  services.fstrim.interval = "weekly";

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };
}
