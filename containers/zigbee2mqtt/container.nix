{ lib, ... }:

{
  containers.mosquitto = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    bindMounts = {
      "/var/lib/mosquitto" = {
        hostPath = "/data/mqtt";
        isReadOnly = false;
      };
      "/etc/mosquitto/secrets" = {
        hostPath = "/etc/nixos/secrets/mqtt";
        isReadOnly = true;
      };
    };
    config = import ./mqtt-default.nix;
  };

  containers.zigbee2mqtt = {
    autoStart = true;
    privateNetwork = true;
    
    # Propojení s fyzickou sítí routeru přes bridge br0
    macvlans = [ "br0" ];
    
    # OPRAVA: privateUsers často rozbíjí přístup k USB (protože mění UID). 
    # Pokud to není nezbytně nutné, doporučuji vypnout pro přístup k HW.
    # privateUsers = "identity"; 

    allowedDevices = [
      {
        node = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
        modifier = "rw";
      }
    ];

    bindMounts = {
      # 1. Perzistentní data
      "/data" = {
        hostPath = "/data/zigbee2mqtt";
        isReadOnly = false;
      };

      # 2. Mapování USB koordinátoru
      "/dev/zigbee" = {
        hostPath = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
        isReadOnly = false;
      };

      # 3. TAJNÉ ÚDAJE
      # Soubor bude v kontejneru dostupný jako /run/secrets/mqtt.env
      "/run/secrets/mqtt.env" = {
        hostPath = "/etc/nixos/secrets/zigbee2mqtt/mqtt-secret.env";
        isReadOnly = true;
      };
    };

    # OPRAVA: Pro deklarativní konfiguraci se používá 'config = import ...', nikoliv 'path'.
    config = import ./zigbee2mqtt-default.nix;
  };
}