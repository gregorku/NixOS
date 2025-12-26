{ config, pkgs, ... }:

{
  system.stateVersion = "25.05";

  networking = {
    hostName = "caddy";
    useDHCP = true;
  };

  services.caddy = {
    enable = true;
    virtualHosts."xxx.ftp.org".extraConfig = ''
      reverse_proxy 192.168.100.230:8123
    '';
  };
}
