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

  # Fixní UID pro postgres (standard v NixOS je 71)
  users.users.postgres.uid = 71;
  users.groups.postgres.gid = 71;

  services.postgresql = {
    enable = true;
    dataDir = "/var/lib/postgresql/data"; [cite_start]# [cite: 7]

    # Povolení připojení z HA kontejneru
    settings = { listen_addresses = "*"; };
    authentication = pkgs.lib.mkOverride 10 ''
      local   all             all                                     trust
      host    homeassistant   homeassistant   0.0.0.0/0               trust
    '';

    ensureDatabases = [ "homeassistant" ];
    ensureUsers = [{
      name = "homeassistant";
      ensureDBOwnership = true;
    }];
  };

  networking.firewall.allowedTCPPorts = [ 5432 ];
}
