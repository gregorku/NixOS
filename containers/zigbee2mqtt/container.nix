{ ... }:

{
  containers.zigbee2mqtt = {
    autoStart = true;

    bindMounts = {
      "/data" = {
        hostPath = "/data/zigbee2mqtt";
        isReadOnly = false;
      };

      "/dev/zigbee" = {
        hostPath = "/dev/serial/by-id/usb-ITEAD_SONOFF_Zigbee_3.0_USB_Dongle_Plus_V2_20240212-if00-port0";
        isReadOnly = false;
      };
    };

    config = ./configuration.nix;
  };
}
