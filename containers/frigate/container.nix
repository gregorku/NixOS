{ config, pkgs, ... }:

{
  containers.frigate = {
    autoStart = true;
    
    # KLÍČOVÉ: Propojení USB z hostitele do kontejneru
    # Toto umožní kontejneru vidět Coral i předtím, než vznikne /dev/apex_0
    bindMounts = {
      "/dev/bus/usb" = { hostPath = "/dev/bus/usb"; isReadOnly = false; };
    };

    config = { config, pkgs, ... }: {
      # Povolení unfree balíčků uvnitř kontejneru (pokud je třeba pro Coral/GPU)
      nixpkgs.config.allowUnfree = true;

      services.frigate = {
        enable = true;
        
        # OPRAVA CHYBY: Hostname je povinný
        hostname = "frigate.doma.lan";

        settings = {
          # Detektory - definice Coralu
          detectors.coral = {
            type = "edgetpu";
            device = "usb";
          };

          # Zde pokračuje vaše stávající konfigurace (kamery, atd.)
          # cameras = { ... };
        };
      };

      # Instalace knihoven pro Coral i uvnitř kontejneru
      environment.systemPackages = [ pkgs.libedgetpu ];

      # Firewall v kontejneru (pokud ho máte aktivní)
      networking.firewall.allowedTCPPorts = [ 5000 1935 ];
      
      system.stateVersion = "25.11";
    };
  };
}