{ lib, ... }:

{
  containers.frigate = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;
    privateUsers = "identity";

    extraFlags = [
      "--device=/dev/bus/usb"
    ];

    bindMounts = {
      "/data/frigate" = {
        hostPath = "/data/frigate";
        isReadOnly = false;
      };
    };

    config = import ./frigate-default.nix;
  };
}
