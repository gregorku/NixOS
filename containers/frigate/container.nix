{ config, pkgs, ... }:

{
  containers.frigate = {
    autoStart = true;
    ephemeral = true;
    config = import ./frigate-default.nix;

    privateNetwork = true;
    macvlans = [ "br0" ]; 

    bindMounts = {
      "/var/lib/frigate" = { hostPath = "/data/frigate"; isReadOnly = false; };
      "/media/frigate" = { hostPath = "/video"; isReadOnly = false; };
      "/dev/bus/usb" = { hostPath = "/dev/bus/usb"; isReadOnly = false; };
      "/dev/dri" = { hostPath = "/dev/dri"; isReadOnly = false; };
      # SEM UŽ /dev/shm NEDÁVEJTE
    };

    extraFlags = [ 
      "--system-call-filter=@system-service"
      # Vytvoří 512MB sdílené paměti přímo pro kontejner
      "--tmpfs=/dev/shm:size=512M,mode=1777"
    ];

    # Práva definujeme pouze zde, bez zástupných znaků
    allowedDevices = [
      { node = "/dev/dri/renderD128"; modifier = "rw"; }
      { node = "/dev/bus/usb"; modifier = "rw"; }
    ];
  };
}