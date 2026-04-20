{ config, pkgs, lib, ... }:

let
  wifiIfaces =
    builtins.filter (iface: lib.hasPrefix "wlp" iface)
    (builtins.attrNames config.networking.interfaces);
in
{
  networking.networkmanager.enable = true;
  networking.useNetworkd = false;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    reflector = true;
    allowInterfaces = wifiIfaces ++ [ "incusbr0" ];
  };

  environment.systemPackages = with pkgs; [
    networkmanager
    wireguard-tools
    psmisc
    avahi
    openconnect
    vpn-slice
  ];

  users.users.gregor.extraGroups = [ "networkmanager" ];
}