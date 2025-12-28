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
  
  ## ========================================================
  ## HOOK – sloučení MQTT secrets do configuration.yaml
  ## ========================================================
  systemd.services.zigbee2mqtt.preStart = ''
    set -e

    CFG="/data/configuration.yaml"
    SECRETS="/data/mqtt-secrets.yaml"

    if [ -f "$SECRETS" ]; then
      # smaž starý mqtt blok
      awk '
        BEGIN {skip=0}
        /^mqtt:/ {skip=1; next}
        skip && /^[^ ]/ {skip=0}
        !skip {print}
      ' "$CFG" > /tmp/z2m.yml

      # přidej secrets
      echo "mqtt:" >> /tmp/z2m.yml
      sed 's/^/  /' "$SECRETS" >> /tmp/z2m.yml

      mv /tmp/z2m.yml "$CFG"
    fi
  '';

  # Práva pro přístup k USB
  users.users.zigbee2mqtt.extraGroups = [ "dialout" ];
}