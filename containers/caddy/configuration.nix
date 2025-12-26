{ config, pkgs, lib, ... }:

{
  system.stateVersion = "25.05";
  networking.hostName = "caddy";

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  services.caddy = {
    enable = true;
    virtualHosts."homeassistant.serveftp.org".extraConfig = ''
      reverse_proxy 192.168.100.230:8123
    '';
  };
}
