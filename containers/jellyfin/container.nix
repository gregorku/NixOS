{ lib, ... }:

{
  containers.jellyfin = {
    autoStart = true;
    config = import ./default.nix;
    privateNetwork = true;
    macvlans = [ "br0" ];

    enableTun = true;

    # MAPOVÁNÍ DISKŮ A USB ZAŘÍZENÍ
    bindMounts = {
      "/media" = {
        hostPath = "/data/media";
        isReadOnly = false;
      };
    };
  };
}
