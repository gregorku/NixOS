{ lib, ... }:

{
  containers.mqtt = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    bindMounts = {
      # Perzistentní data (databáze, logy)
      "/var/lib/mosquitto" = {
        hostPath = "/data/mqtt";
        isReadOnly = false;
      };
      # Připojení složky s hesly
      "/etc/mosquitto/secrets" = {
        hostPath = "/etc/nixos/secrets/mqtt";
        isReadOnly = true;
      };
    };

    config = import ./mqtt-default.nix;
  };
}
