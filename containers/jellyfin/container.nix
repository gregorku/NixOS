{ lib, ... }:

{
  containers.jellyfin = {
    autoStart = true;
    config = import ./default.nix;

    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;

    privateUsers = false;

    bindMounts = {
      "/data/media" = {
        hostPath = "/data/media";
        isReadOnly = false;
      };
    };
  };
}
