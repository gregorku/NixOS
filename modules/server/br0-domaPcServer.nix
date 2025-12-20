{ config, lib, pkgs, ... }:

{
  ## =========================
  ## NETWORK MANAGER
  ## =========================
  networking.networkmanager.enable = true;
  networking.useNetworkd = false;

  ## =========================
  ## BRIDGE br0 (host + VM + containers)
  ## =========================
  networking.networkmanager.connections = {
    br0 = {
      connection = {
        id = "br0";
        type = "bridge";
        interface-name = "br0";
        autoconnect = true;
      };

      ipv4 = {
        method = "auto"; # DHCP z LAN
      };

      ipv6 = {
        method = "ignore";
      };
    };

    br0-enp2s0 = {
      connection = {
        id = "br0-enp2s0";
        type = "ethernet";
        interface-name = "enp2s0";
        master = "br0";
        slave-type = "bridge";
        autoconnect = true;
      };
    };
  };

  ## =========================
  ## FIREWALL
  ## =========================
  networking.firewall.trustedInterfaces = [ "br0" ];
}
