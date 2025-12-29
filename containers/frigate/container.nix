{ config, pkgs, ... }:

{
  containers.frigate = {
    autoStart = true;
    # ... vaše ostatní nastavení ...

    config = { config, pkgs, ... }: {
      # Instalace knihovny i uvnitř kontejneru
      environment.systemPackages = [ pkgs.libedgetpu ];
      
      # Frigate konfigurace (zjednodušeně)
      services.frigate = {
        enable = true;
        settings = {
          detectors.coral = {
            type = "edgetpu";
            device = "usb"; # Frigate si ho najde přes USB sběrnici
          };
          # ... zbytek frigate.yml ...
        };
      };
    };

    # KLÍČOVÉ: Povolení přístupu k hardwaru z hostitele do kontejneru
    bindMounts = {
      "/dev/bus/usb" = { hostPath = "/dev/bus/usb"; isReadOnly = false; };
    };
  };
}