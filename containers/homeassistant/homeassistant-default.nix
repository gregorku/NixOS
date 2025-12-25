{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";
  networking.hostName = "homeassistant";

  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  virtualisation.containers.containersConf.settings = {
    containers.keyring = false;
  };

  environment.systemPackages = with pkgs; [
    mc
  ];
  ## =========================
  ## FIREWALL
  ## =========================
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 8123 ];

  users.users.homeassistant = {
    uid = 911;
    isSystemUser = true;
    group = "homeassistant";
    extraGroups = [ "dialout" ];
  };
  users.groups.homeassistant.gid = 911;

  services.home-assistant = {
    enable = true;
    configDir = "/config";

    config = import ./configuration.nix;

    extraComponents = [
      "hardware"
      "usb"
      "bluetooth"
     ];

    extraPackages = python3Packages: with python3Packages; [
      psycopg2
      gtts
    ];
  };
}
