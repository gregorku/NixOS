{ config, pkgs, lib, ... }:

{
  system.stateVersion = "25.05";

  networking = {
    hostName = "caddy";
    useDHCP = lib.mkForce true;

    firewall.allowedTCPPorts = [ 443 ];
  };

  services.caddy = {
    enable = true;
    virtualHosts."homeassistant.serveftp.org".extraConfig = ''
      reverse_proxy 192.168.100.230:8123
    '';
  };
}
