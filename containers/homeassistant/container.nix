{ lib, ... }:

{
  containers.homeassistant = {
    autoStart = true;
    config = import ./default.nix;

    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;
    privateUsers = "identity";

    bindMounts = {
      "/data/homeassistant" = {
        hostPath = "/data/homeassistant";
        isReadOnly = false;
      };

      # Zigbee SMLIGHT koordinátor
      "/dev/zigbee" = {
        hostPath = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
        isReadOnly = false;
      };
    };
  };
}
