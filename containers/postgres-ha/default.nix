{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";
  networking.hostName = "postgres-ha";

  networking.useNetworkd = true;
  systemd.network.enable = true;
  services.resolved.enable = false;
  networking.useHostResolvConf = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  virtualisation.containers.containersConf.settings = {
    containers.keyring = false;
  };

  services.postgresql = {
    enable = true;
    dataDir = "/var/lib/postgresql/data";

    ensureDatabases = [ "homeassistant" ];
    ensureUsers = [{
      name = "homeassistant";
      ensureDBOwnership = true;
    }];
  };

  networking.firewall.allowedTCPPorts = [ 5432 ];
}
