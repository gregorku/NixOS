{ config, pkgs, lib, ... }:

{
  containers.server1 = {
    autoStart = true;
    privateNetwork = false;  # Použít host network

    # Přidat tyto flagy pro stabilitu
    extraFlags = [
      "--bind=/tmp"
      "--bind=/run"
      "--bind=/sys/fs/cgroup"
    ];

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "server1";
      system.stateVersion = "25.05";

      ##################################################
      # ŘEŠENÍ KONFLIKTU: Vynutit DHCP a vypnout NetworkManager
      ##################################################
      networking.networkmanager.enable = lib.mkForce false;  # VYPNOUT
      networking.useDHCP = lib.mkForce true;  # VYNUTIT DHCP

      # Explicitně zakázat všechny ruční síťové konfigurace
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
            -p 8443:9000 \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v portainer_data:/data \
            portainer/portainer-ee:2.33.6";
          Restart = "always";
          RestartSec = "10s";
        };
        wantedBy = [ "multi-user.target" ];
      };

      ##################################################
      # Firewall v kontejneru
      ##################################################
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 8443 ];

      ##################################################
      # SSH - minimalizovat konflikty
      ##################################################
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "prohibit-password";
        };
      };

      # Zakázat zbytečné služby, které mohou konfliktovat
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
