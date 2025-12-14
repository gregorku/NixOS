{ config, lib, ... }:

let
  opts = [
    "compress=zstd:3"
    "noatime"
  ];
in
{
  fileSystems."/".options = lib.mkDefault (opts ++ [ "subvol=@" ]);
  fileSystems."/home".options = lib.mkDefault (opts ++ [ "subvol=@home" ]);
  fileSystems."/var/log".options = lib.mkDefault (opts ++ [ "subvol=@log" ]);
  fileSystems."/var/cache".options = lib.mkDefault (opts ++ [ "subvol=@cache" ]);
  fileSystems."/.snapshots".options = lib.mkDefault (opts ++ [ "subvol=@snapshots" ]);

  services.fstrim.enable = true;
}
