{ config, ... }:

{
  # ----------------------
  # ZFS tuning pro Incus
  # ----------------------

  # doporučené vlastnosti datasetu
  system.activationScripts.zfsIncusTuning.text = ''
    zfs set compression=lz4 zfs-pool-incus
    zfs set atime=off zfs-pool-incus

    zfs set recordsize=16K zfs-pool-incus/incus
    zfs set logbias=throughput zfs-pool-incus/incus
  '';

  # ----------------------
  # Snapshoty pro Incus dataset
  # ----------------------
  services.zfs.autoSnapshot = {
    enable = true;

    # můžeš později zúžit jen na incus dataset
    # flags = "-r zfs-pool-incus/incus";

    frequent = 4;
    hourly   = 24;
    daily    = 7;
    weekly   = 4;
    monthly  = 3;
  };
}