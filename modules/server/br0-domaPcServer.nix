{ config, lib, pkgs, ... }:

{
  ## =========================
  ## NetworkManager
  ## =========================
  networking.networkmanager.enable = true;
  networking.useNetworkd = false;

  ## =========================
  ## Bridge br0 (host + VM + containers)
  ## =========================
  networking.networkmanager.ensureProfiles = {
    br0 = {
      text = ''
        [connection]
        id=br0
        type=bridge
        interface-name=br0
        autoconnect=true

        [bridge]
        stp=false

        [ipv4]
        method=auto

        [ipv6]
        method=ignore
      '';
    };

    br0-enp2s0 = {
      text = ''
        [connection]
        id=br0-enp2s0
        type=ethernet
        interface-name=enp2s0
        master=br0
        slave-type=bridge
        autoconnect=true

        [ipv4]
        method=disabled

        [ipv6]
        method=ignore
      '';
    };
  };

  ## =========================
  ## Firewall
  ## =========================
  networking.firewall.trustedInterfaces = [ "br0" ];
}
