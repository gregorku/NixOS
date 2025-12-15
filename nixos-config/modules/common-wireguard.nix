{ config, pkgs, ... }:

{
  # WireGuard kernel modul (automaticky u nových kernelů, ale explicitní je OK)
  networking.wireguard.enable = true;

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  # Doporučeno
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
