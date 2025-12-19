{ config, ... }:

{
  networking.useNetworkd = true;
  networking.useDHCP = false;

  networking.bridges.br0.interfaces = [ "enp1s0" ];

  networking.interfaces.br0.ipv4.addresses = [{
    address = "10.0.0.1";
    prefixLength = 24;
  }];

  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "br0" ];
  networking.nat.externalInterface = "enp1s0";
}
