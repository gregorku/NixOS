{ config, ... }:

{
  # Server-safe swap pro ZFS (žádný diskový swap)
  zramSwap = {
    enable = true;
    memoryPercent = 50; # server má 32 GB RAM
  };
}
