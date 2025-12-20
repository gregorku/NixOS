{ config, lib, pkgs, ... }:

{
  ## =========================
  ## systemd-networkd
  ## =========================
  networking.useNetworkd = true;
  systemd.network.enable = true;

  ## =========================
  ## Bridge br0
  ## =========================
  networking.bridges.br0.interfaces = [ "enp2s0" ];

  ## =========================
  ## DHCP na bridge
  ## =========================
  networking.interfaces.br0.useDHCP = true;

  ## =========================
  ## Firewall
  ## =========================
  networking.firewall.trustedInterfaces = [ "br0" ];
}
