{ lib, ... }:

{
  containers.zigbee2mqtt = {
    autoStart = true;
    privateNetwork = true;
    
    # Propojení s fyzickou sítí routeru přes bridge br0
    macvlans = [ "br0" ];

    # Izolace uživatelů (volitelné, ale bezpečnější)
    privateUsers = "identity";

    # Povolení přístupu k USB hardwaru na úrovni cgroups
    allowedDevices = [
      {
        node = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
        modifier = "rw";
      }
    ];

    # Mapování souborů a složek z hostitele do kontejneru
    bindMounts = {
      # 1. Perzistentní data (databáze zařízení, stav sítě)
      "/data" = {
        hostPath = "/data/zigbee2mqtt";
        isReadOnly = false;
      };

      # 2. Mapování USB koordinátoru na fixní a krátký název
      "/dev/zigbee" = {
        hostPath = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
        isReadOnly = false;
      };

      # 3. TAJNÉ ÚDAJE (IP adresa brokeru, hesla), které nejsou v Gitu
      # Tento soubor se v kontejneru objeví v /data/mqtt-secrets.yaml
      "/data/mqtt-secrets.yaml" = {
        hostPath = "/etc/nixos/secrets/zigbee2mqtt/mqtt-secret.yaml";
        isReadOnly = true;
      };
    };

    # Načtení vnitřní konfigurace (logika, sítě, služby)
    path = ./zigbee2mqtt-default.nix;
  };

  containers.mqtt = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ]; # Stejný bridge jako u Zigbee2MQTT

    bindMounts = {
      # Perzistentní data (databáze, logy)
      "/var/lib/mosquitto" = {
        hostPath = "/data/mqtt";
        isReadOnly = false;
      };
      # Připojení složky s hesly
      "/etc/mosquitto/secrets" = {
        hostPath = "/etc/nixos/secrets/mqtt";
        isReadOnly = true;
      };
    };

    path = ./mqtt-default.nix;
  };
}
