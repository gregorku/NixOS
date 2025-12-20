{ config, pkgs, ... }:

{
  services.cockpit = {
    enable = true;
    openFirewall = true;

    settings = {
      WebService = {
        Protocol = "https";
        Port = 9090;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    cockpit
    cockpit-machines
  ];
}
