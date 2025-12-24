{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";
  networking.hostName = "homeassistant";
  networking.firewall.enable = false;

  networking.useNetworkd = true;
  systemd.network.enable = true;
  services.resolved.enable = false;
  networking.useHostResolvConf = true;


  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  # KEYRING FIX
  virtualisation.containers.containersConf.settings = {
    containers.keyring = false;
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    nano
    mc
  ];

  users.users.homeassistant = {
    isSystemUser = true;
    group = "homeassistant";
    extraGroups = [ "dialout" ];
    home = "/var/lib/homeassistant";
    createHome = true;
  };

  users.groups.homeassistant = {};

  networking.firewall.allowedTCPPorts = [ 8123 ];

  services.home-assistant = {
  enable = true;
  configDir = "/data/homeassistant/config";
  openFirewall = true;

  extraPackages = python3Packages: with python3Packages; [
    psycopg2
  ];
};

