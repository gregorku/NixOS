{ config, pkgs, ... }:

{
  containers.frigate = {
    autoStart = true;
    
    # Pouze základní bezpečné mapování
    bindMounts = {
      "/dev/bus/usb" = { hostPath = "/dev/bus/usb"; isReadOnly = false; };
    };

    config = { config, pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      services.frigate = {
        enable = true;
        hostname = "frigate.doma.lan";
        settings = {
          detectors.coral = {
            type = "edgetpu";
            device = "usb";
          };
          cameras.test_camera = {
            enabled = false;
            ffmpeg.inputs = [{ path = "rtsp://127.0.0.1:554/live"; roles = [ "detect" ]; }];
          };
        };
      };
      environment.systemPackages = [ pkgs.libedgetpu ];
      system.stateVersion = "25.11";
    };
  };
}