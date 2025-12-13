{ config, lib, pkgs, ... }:

{
  services.nxserver.enable = true;

  networking.firewall.allowedTCPPorts = [ 4000 ];
}
