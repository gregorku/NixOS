{ lib, config, ... }:

{
  ##################################################################
  # HOME ASSISTANT – kontejner
  ##################################################################
  containers.homeassistant = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;
    privateUsers = "identity";

    # 🔑 PŘEDÁNÍ pkgs2411 DO KONTEJNERU
    _module.args.pkgs2411 = config._module.args.pkgs2411;

    bindMounts = {
      "/config" = {
        hostPath = "/data/homeassistant";
        isReadOnly = false;
      };
    };

    config = import ./homeassistant-default.nix;
  };

  ##################################################################
  # POSTGRES – kontejner
  ##################################################################
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


