{ config, pkgs, ... }:

{
  containers.frigate = {
    autoStart = true;
    
    # 1. Povolení surového přístupu k hardwaru pro nspawn
    additionalCapabilities = [ "CAP_SYS_RAWIO" ];

    # 2. Mapování USB sběrnice (ponecháme)
    bindMounts = {
      "/dev/bus/usb" = { hostPath = "/dev/bus/usb"; isReadOnly = false; };
    };

    # 3. Povolení přístupu k USB zařízením v cgroups
    extraFlags = [ "--property=DeviceAllow=char-usb_device rwm" ];

    config = { config, pkgs, ... }: {
      # ... vaše stávající config.services.frigate ...
      # Ujistěte se, že uvnitř zůstává:
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