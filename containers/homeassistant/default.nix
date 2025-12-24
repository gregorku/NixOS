{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";
  networking.hostName = "homeassistant";

  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = false;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  virtualisation.containers.containersConf.settings = {
    containers.keyring = false;
  };

  ## =========================
  ## BALÍČKY
  ## =========================
  environment.systemPackages = with pkgs; [
    git vim nano mc
  ];

  services.openssh.enable = true;

  users.users.homeassistant = {
    isSystemUser = true;
    group = "homeassistant";
    extraGroups = [ "dialout" ];
    home = "/var/lib/homeassistant";
    createHome = true;
  };
  users.groups.homeassistant = {};

  networking.firewall.allowedTCPPorts = [ 8123 ];

  services.postgresql = {
    enable = true;
    dataDir = "/data/homeassistant/postgres";
    ensureDatabases = [ "homeassistant" ];
    ensureUsers = [{
      name = "homeassistant";
      ensureDBOwnership = true;
    }];
  };

  services.home-assistant = {
    enable = true;
    configDir = "/data/homeassistant/config";
    openFirewall = true;

    config = {
      default_config = {};
    };

    extraPackages = python3Packages: with python3Packages; [
      psycopg2
    ];
  };
}
