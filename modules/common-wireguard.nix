{ config, pkgs, ... }:

{
  networking.wireguard.enable = true;

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}