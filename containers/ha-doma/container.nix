{ lib, config, ... }:

{
  containers.homeassistant = {
    autoStart = true;
    privateNetwork = false;
    macvlans = [ "br0" ];
    enableTun = true;
    privateUsers = "identity";

    bindMounts = {
      "/config" = {
        hostPath = "/data/homeassistant";
        isReadOnly = false;
      };
    };
    config = import ./homeassistant-default.nix;
  };

  containers.postgres-ha = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    privateUsers = "identity";

    bindMounts = {
      "/var/lib/postgresql" = {
        hostPath = "/data/databaze/postgres-ha";
        isReadOnly = false;
      };
    };
    config = import ./postgres-default.nix;
  };
}

