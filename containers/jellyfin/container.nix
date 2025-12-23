{ lib, ... }:

{
  containers.jellyfin = {
    autoStart = true;
    config = import ./default.nix;

    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;

    uidMap = [
      { hostID = 0; containerID = 0; size = 65536; }
    ];
    gidMap = [
      { hostID = 0; containerID = 0; size = 65536; }
    ];

    bindMounts = {
      "/data/media" = {
        hostPath = "/data/media";
        isReadOnly = false;
      };
    };
  };
}
