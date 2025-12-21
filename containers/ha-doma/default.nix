{ config, pkgs, ... }:

{
  system.stateVersion = "25.05";

  networking.hostName = "ha-doma";

  networking.useNetworkd = true;
  systemd.network.enable = true;

  systemd.network.networks."eth0" = {
    matchConfig.Name = "host0";
    networkConfig = {
      DHCP = "yes";
    };
  };

  services.openssh.enable = true;
}
