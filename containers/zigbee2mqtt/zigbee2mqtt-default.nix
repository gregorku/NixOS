{ config, pkgs, lib, ... }:

{
  system.stateVersion = "25.11";
  networking.hostName = "zigbee2mqtt";
  
  ## SÍŤOVÁ KONFIGURACE
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.enable = true;
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
    dhcpV4Config.ClientIdentifier = "mac";
  };
  networking.firewall.allowedTCPPorts = [ 8080 ];

  ## SLUŽBA ZIGBEE2MQTT
  services.zigbee2mqtt = {
    enable = true;
    dataDir = "/data"; 

    settings = {
      serial = {
        port = "/dev/zigbee";
        adapter = "ember";
      };

      frontend = {
        port = 8080;
        host = "0.0.0.0";
      };

      permit_join = false;
      
      # MQTT sekci necháváme prázdnou, bude naplněna dynamicky z EnvironmentFile
      mqtt = {};
    };
  };

  # Oprava: Načtení environment proměnných a spuštění
  systemd.services.zigbee2mqtt = {
    serviceConfig = {
      # Načte soubor /run/secrets/mqtt.env (namapovaný v container.nix)
      EnvironmentFile = "/run/secrets/mqtt.env";
    };

    # Přepíšeme startovací skript, abychom namapovali vaše proměnné (MQTT_SERVER)
    # na proměnné, které Zigbee2MQTT očekává (ZIGBEE2MQTT_CONFIG_MQTT_SERVER).
    script = lib.mkForce ''
      export ZIGBEE2MQTT_CONFIG_MQTT_SERVER="$MQTT_SERVER"
      export ZIGBEE2MQTT_CONFIG_MQTT_USER="$MQTT_USER"
      export ZIGBEE2MQTT_CONFIG_MQTT_PASSWORD="$MQTT_PASSWORD"
      
      # Spuštění samotné služby
      ${pkgs.zigbee2mqtt}/bin/zigbee2mqtt
    '';
  };

  users.users.zigbee2mqtt.extraGroups = [ "dialout" ];
}