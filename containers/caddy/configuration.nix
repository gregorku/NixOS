{ config, pkgs, ... }:

{
  system.stateVersion = "25.05";

  networking = {
    hostName = "caddy";
    useDHCP = false;
    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.100.231";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.100.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    firewall.allowedTCPPorts = [ 443 ];
  };

  services.caddy = {
    enable = true;
    virtualHosts."homeassistant.serveftp.org".extraConfig = ''
      reverse_proxy 192.168.100.230:8123
    '';
  };
}
