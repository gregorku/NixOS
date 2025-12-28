{ lib, ... }:

{
  containers.frigate = {
    autoStart = true;
    config = import ./frigate-default.nix;

    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;
    privateUsers = "identity";

    bindMounts = {
  "/data/frigate" = {
    hostPath = "/data/frigate";
    isReadOnly = false;
    mountOptions = [ "bind" "rw" "exec" ];
      };
    };
  };
}
