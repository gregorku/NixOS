{ config, pkgs, lib, ... }:

{
  system.stateVersion = "24.05";
  networking.hostName = "caddy";

  ## =========================
  ## SÍŤ – macvlan (mv-*)
  ## =========================
  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  services.caddy = {
    enable = true;
    virtualHosts."homeassistant.serveftp.org".extraConfig = ''
      reverse_proxy 192.168.100.230:8123
    '';

  systemd.services.caddy.serviceConfig = {
    User = "root";
    Group = "root";
    };  
  };
}
