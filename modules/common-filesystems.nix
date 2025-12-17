{ config, lib, ... }:

let
  opts = [
    "compress=zstd:3"
    "noatime"
  ];
in
{
  # Root filesystem (BTRFS subvolume @)
  fileSystems."/".options = lib.mkDefault (opts ++ [ "subvol=@" ]);

  # Home filesystem (BTRFS subvolume @home)
  fileSystems."/home".options = lib.mkDefault (opts ++ [ "subvol=@home" ]);

  # Periodic TRIM for SSD / NVMe
  services.fstrim.enable = true;
}
