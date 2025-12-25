{ lib, ... }:

{
  # Kontejner pro Home Assistant
  containers.homeassistant = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    enableTun = true;
    privateUsers = "identity"; # [cite_start]Mapování UID 1:1 s hostitelem [cite: 2]

    bindMounts = {
      # [cite_start]Celý obsah /data/homeassistant bude v kontejneru vidět jako /config [cite: 2]
      "/config" = {
        hostPath = "/data/homeassistant";
        isReadOnly = false;
      };

      "/dev/zigbee" = {
        hostPath = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
        isReadOnly = false;
      };
    };
    config = import ./homeassistant-default.nix;
  };

  # Kontejner pro PostgreSQL
  containers.postgres-ha = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "br0" ];
    privateUsers = "identity"; # [cite_start]Nutné pro zápis DB na disk [cite: 2]

    bindMounts = {
      "/var/lib/postgresql" = {
        hostPath = "/data/homeassistant/postgres";
        isReadOnly = false;
      };
    };
    config = import ./postgres-default.nix;
  };
}
