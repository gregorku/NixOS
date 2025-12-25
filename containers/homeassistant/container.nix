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
      "/dev/zigbee" = {
        hostPath = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
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
        hostPath = "/data/homeassistant/postgres";
        isReadOnly = false;
      };
    };
    config = import ./postgres-default.nix;
  };
}
