{ lib, ... }:

{
  containers.frigate = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;
    privateUsers = "identity";

    bindMounts = {
  "/data/frigate" = {
    hostPath = "/data/frigate";
    isReadOnly = false;
  };

  "/dev/bus/usb" = {
    hostPath = "/dev/bus/usb";
    isReadOnly = false;
  };
};

    config = import ./frigate-default.nix;
  };
}
