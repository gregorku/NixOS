{ lib, ... }:

{
  containers.frigate = {
    autoStart = true;
    config = import ./frigate-default.nix;

    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;

    # Stejné UID/GID jako hostitel – bez permission pekla
    privateUsers = "identity";

    bindMounts = {
      "/data/frigate" = {
        hostPath = "/data/frigate";
        isReadOnly = false;
      };
    };
  };
}
