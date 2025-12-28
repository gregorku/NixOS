{ config, pkgs, ... }:

{
  system.stateVersion = "24.11";
  networking.hostName = "homeassistant";

  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  networking.firewall.allowedTCPPorts = [ 8123 ];

  users.users.homeassistant = {
    isSystemUser = true;
    group = "homeassistant";
  };
  users.groups.homeassistant = {};

  services.home-assistant = {
    enable = true;
    configDir = "/config";

    extraPackages = python3Packages: with python3Packages; [
      paho-mqtt
      aioesphomeapi
      psycopg2
    ];
  };
}
