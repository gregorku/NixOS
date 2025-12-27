{ config, pkgs, ... }:

{
  system.stateVersion = "25.05";

  networking.useDHCP = true;

  environment.systemPackages = with pkgs; [
    nodejs
    yarn
    git
  ];

  systemd.services.zigbee2mqtt = {
    description = "Zigbee2MQTT";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.nodejs}/bin/node /data/index.js";
      WorkingDirectory = "/data";
      Restart = "always";
    };
  };
}
