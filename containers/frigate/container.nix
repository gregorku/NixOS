{ config, pkgs, ... }:

{
  containers.frigate = {
    autoStart = true;
    
    # Propojení USB sběrnice, aby kontejner mohl inicializovat Coral
    bindMounts = {
      "/dev/bus/usb" = { hostPath = "/dev/bus/usb"; isReadOnly = false; };
    };

    config = { config, pkgs, ... }: {
      # Nutné pro libedgetpu a případné ovladače
      nixpkgs.config.allowUnfree = true;

      services.frigate = {
        enable = true;
        hostname = "frigate.doma.lan"; # Povinné
        
        settings = {
          # Detektor Coral
          detectors.coral = {
            type = "edgetpu";
            device = "usb";
          };

          # OPRAVA CHYBY: Musí zde být definována alespoň jedna (třeba i vypnutá) kamera
          cameras.test_camera = {
            enabled = false;
            ffmpeg.inputs = [{
              path = "rtsp://127.0.0.1:554/live";
              roles = [ "detect" ];
            }];
          };

          # Minimální nutná konfigurace pro start
          mqtt.enabled = false; 
        };
      };

      environment.systemPackages = [ pkgs.libedgetpu ];
      system.stateVersion = "25.11";
    };
  };
}