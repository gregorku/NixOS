{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  networking.useDHCP = false;
  networking.useNetworkd = true;
  services.resolved.enable = true;

  systemd.network.enable = true;
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    libedgetpu
  ];

  users.users.frigate = {
    isSystemUser = true;
    group = "frigate";
    extraGroups = [ "docker" ];
  };
  users.groups.frigate = {};

  systemd.services.frigate = {
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    wants = [ "docker.service" ];

    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /data/frigate/docker-compose.yml up";
      ExecStop  = "${pkgs.docker-compose}/bin/docker-compose -f /data/frigate/docker-compose.yml down";
      Restart = "always";
      User = "root";
    };
  };

  system.stateVersion = "25.11";
}
