{ lib, ... }:

{
  containers.postgres-ha = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    config = import ./default.nix;

    bindMounts = {
      "/var/lib/postgresql" = {
        hostPath = "/data/homeassistant/postgres";
        isReadOnly = false;
      };
    };
  };
}
