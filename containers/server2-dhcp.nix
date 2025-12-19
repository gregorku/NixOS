{ config, pkgs, lib, ... }:

{
  containers.server2 = {
    autoStart = true;
    privateNetwork = false;

    extraFlags = [
      "--bind=/tmp"
      "--bind=/run"
      "--bind=/sys/fs/cgroup"
    ];

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "server2";
      system.stateVersion = "25.05";

      ##################################################
      # ŘEŠENÍ KONFLIKTU
      ##################################################
      networking.networkmanager.enable = lib.mkForce false;
      networking.useDHCP = lib.mkForce true;

      networking.dhcpcd.enable = false;
      networking.interfaces = {};
      networking.defaultGateway = lib.mkForce null;
      networking.nameservers = lib.mkForce [];

      ##################################################
      # Docker
      ##################################################
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        package = pkgs.docker_27;
        daemon.settings = {
          ip = "0.0.0.0";
        };
      };

      ##################################################
      # Portainer Business Edition
      ##################################################
      systemd.services.portainer = {
        description = "Portainer Business Edition 2.33.6";
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.docker}/bin/docker run \
            --name portainer \
            --restart=always \
            -p 9443:9000 \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v portainer_data:/data \
            portainer/portainer-ee:2.33.6";
          Restart = "always";
          RestartSec = "10s";
        };
        wantedBy = [ "multi-user.target" ];
      };

      ##################################################
      # Firewall
      ##################################################
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 9443 ];

      ##################################################
      # SSH
      ##################################################
      services.openssh.enable = true;

      services.resolved.enable = false;
      services.timesyncd.enable = false;

      ##################################################
      # Základní balíčky
      ##################################################
      environment.systemPackages = with pkgs; [
        vim htop curl wget git tmux docker-compose
      ];
    };
  };
}
