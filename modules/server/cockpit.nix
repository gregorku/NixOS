{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;

    settings = {
      WebService = {
        AllowUnencrypted = true;
        Origins = "*";
      };
    };
  };
}
