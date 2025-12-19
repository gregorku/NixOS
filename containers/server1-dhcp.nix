{ config, pkgs, lib, ... }:

{
  containers.server1 = {
    autoStart = true;
    privateNetwork = false;  # Použít host network (DHCP)

    extraFlags = [
      "--bind=/tmp"
      "--bind=/run"
      "--bind=/sys/fs/cgroup"
    ];

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "server1";
      system.stateVersion = "25.05";

      # DHCP a síť
      networking.useDHCP = true;
      networking.networkmanager.enable = false;

      # Docker
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        package = pkgs.docker_27;
      };

      # Portainer Business Edition
      systemd.services.portainer = {
        description = "Portainer Business Edition 2.33.6";
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.docker}/bin/docker run \
            --name portainer \
            --restart=always \
            -p 8443:9000 \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v portainer_data:/data \
            portainer/portainer-ee:2.33.6";
          Restart = "always";
          RestartSec = "10s";
        };
        wantedBy = [ "multi-user.target" ];
      };

      # Firewall v kontejneru
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 8443 ];

      # SSH
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;  # Pro jednoduchost
          PermitRootLogin = "yes";
        };
      };

      users.users.root.initialPassword = "test123";

      # Základní balíčky
      environment.systemPackages = with pkgs; [
        nano vim htop curl wget git tmux docker-compose
      ];
    };
  };
}
