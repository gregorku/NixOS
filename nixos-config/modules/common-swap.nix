{ config, pkgs, ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;   # použije max 50 % RAM
  };

  # Doporučené chování kernelu
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;   # vysoká swappiness = preferuje zram
  };
}
