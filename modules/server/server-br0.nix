{ config, lib, ... }:

let
  cfg = config.server.br0;
in
{
  options.server.br0 = {
    enable = lib.mkEnableOption "Enable br0 bridge";

    interface = lib.mkOption {
      type = lib.types.str;
      description = "Physical interface to bridge";
    };
  };

  config = lib.mkIf cfg.enable {

    # použij systemd-networkd (NE NetworkManager)
    networking.useNetworkd = true;
    systemd.network.enable = true;

    # vypnout DHCP na fyzickém interface
    networking.interfaces.${cfg.interface}.useDHCP = false;

    # bridge
    networking.bridges.br0.interfaces = [ cfg.interface ];

    # DHCP na bridge
    networking.interfaces.br0.useDHCP = true;

    # firewall trust
    networking.firewall.trustedInterfaces = [ "br0" ];
  };
}