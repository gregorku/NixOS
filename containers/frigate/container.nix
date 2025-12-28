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
      "/dev/shm" = { hostPath = "/dev/shm"; isReadOnly = false; };
      "/media/frigate" = { hostPath = "/video"; isReadOnly = false; };
      "/dev/bus/usb" = { hostPath = "/dev/bus/usb"; isReadOnly = false; };
      "/dev/dri" = { hostPath = "/dev/dri"; isReadOnly = false; };
    };
    
    # Zjednodušené Flags - nspawn v NixOS automaticky povolí zařízení 
    # v bindMounts, pokud nejsou flags v konfliktu.
    extraFlags = [ 
      "--system-call-filter=@system-service"
    ];

    # Práva definujeme pouze zde, bez zástupných znaků
    allowedDevices = [
      { node = "/dev/dri/renderD128"; modifier = "rw"; }
      { node = "/dev/bus/usb"; modifier = "rw"; }
    ];
  };
}