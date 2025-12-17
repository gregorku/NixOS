{ config, ... }:

{
  networking.useNetworkd = true;
  networking.useDHCP = false;

  networking.bridges.br0.interfaces = [ "enp1s0" ];

  networking.interfaces.br0.useDHCP = true;
}
