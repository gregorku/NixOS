{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";
  networking.hostName = "mqtt-broker";

  ## ========================================================
  ## SÍŤOVÁ KONFIGURACE (DHCP přes macvlan)
  ## ========================================================
  networking.useDHCP = false;
  networking.useNetworkd = true;
  systemd.network.enable = true;

# OPRAVA: Vypnutí sdílení resolv.conf z hostitele
  networking.useHostResolvConf = false; 
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
    dhcpV4Config.ClientIdentifier = "mac";
  };

  # Port pro MQTT (1883)
  networking.firewall.allowedTCPPorts = [ 1883 ];

  ## ========================================================
  ## SLUŽBA MOSQUITTO
  ## ========================================================
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        address = "0.0.0.0";
        port = 1883;
        extraConfig = ''
          allow_anonymous false
          password_file /etc/mosquitto/secrets/passwd
        '';
      }
    ];
  };
}