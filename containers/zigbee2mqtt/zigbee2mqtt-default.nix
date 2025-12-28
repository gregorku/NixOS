{ config, pkgs, ... }:

{
  system.stateVersion = "25.11";
  networking.hostName = "zigbee2mqtt";

  ## SÍŤOVÁ KONFIGURACE (Stejná jako u MQTT - pro macvlan nutnost)
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.useHostResolvConf = false; # Vlastní DNS (volitelné)
  services.resolved.enable = true;

  systemd.network.enable = true;
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
    dhcpV4Config.ClientIdentifier = "mac";
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];

  ## SLUŽBA ZIGBEE2MQTT (Deklarativní)
  services.zigbee2mqtt = {
    enable = true;
    dataDir = "/data"; # Data budou v bind-mountu

    settings = {
      serial = {
        port = "/dev/zigbee"; # Odkaz na bind-mount
        adapter = "ember";    # Pro SLZB-07
      };

      frontend = {
        port = 8080;
        host = "0.0.0.0";
      };

      permit_join = false;

      # Načtení externího souboru s hesly (bind-mount)
      #extraSettingsFiles = [ "/data/mqtt-secrets.yaml" ];
    };
  };
  
  # Práva pro přístup k USB
  users.users.zigbee2mqtt.extraGroups = [ "dialout" ];
}