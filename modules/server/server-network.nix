{ config, pkgs, lib, ... }:

{
  # Firewall - POUŽÍT mkForce kvůli konfliktu
  networking.firewall.enable = lib.mkForce true;
  networking.firewall.allowedTCPPorts = [
    22     # SSH
    9090   # Cockpit
    8443   # Portainer server1
    9443   # Portainer server2
  ];

  # Bridge síť pro kontejnery
  networking.bridges = {
    br0.interfaces = [ ];  # Bez fyzického rozhraní
  };

  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "192.168.122.1";
      prefixLength = 24;
    }];
  };

  # NAT pro kontejnery
  networking.nat = {
    enable = true;
    internalInterfaces = [ "br0" ];
    externalInterface = "enp1s0";  # Upravte podle vašeho rozhraní
    forwardPorts = [
      # Přesměrování portů pro Portainery
      { sourcePort = 8443; destination = "192.168.122.10:9000"; }
      { sourcePort = 9443; destination = "192.168.122.11:9000"; }
    ];
  };
}
