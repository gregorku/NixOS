{ lib, ... }:

{
  containers.postgres-ha = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    privateUsers = "identity";

    bindMounts = {
      "/var/lib/postgresql" = {
        hostPath = "/data/homeassistant/postgres";
        isReadOnly = false;
      };
    };
    config = import ./default.nix;
  };
}
