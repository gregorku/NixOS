{ lib, ... }:

{
  containers.jellyfin = {
    autoStart = true;
    config = import ./default.nix;

    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;

    # Použije stejné UID/GID jako hostitel
    privateUsers = "identity";

    bindMounts = {
      "/data/media" = {
        hostPath = "/data/media";
        isReadOnly = false;
      };
    };
  };
}
