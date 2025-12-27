{ lib, ... }:

{
  containers.homeassistant = {
    autoStart = true;
    privateNetwork = true;
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

  containers.zigbee2mqtt = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    privateUsers = "identity";

    allowedDevices = [
      {
        node = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
        modifier = "rw";
      }
    ];

    bindMounts = {
      "/data" = {
        hostPath = "/data/zigbee2mqtt";
        isReadOnly = false;
      };

      "/dev/zigbee" = {
        hostPath = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
        isReadOnly = false;
      };
    };

    config = ./zigbee2mqtt-default.nix;
  };
}

