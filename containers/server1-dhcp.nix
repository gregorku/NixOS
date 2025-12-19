{ config, pkgs, lib, ... }:

{
  containers.server1 = {
    autoStart = true;
    privateNetwork = false;

    extraFlags = [
      "--bind=/tmp"
      "--bind=/run"
    ];

    config = { config, pkgs, lib, ... }: {
      boot.isContainer = true;

      networking.hostName = "server1";
      system.stateVersion = "25.05";

      # Síťová konfigurace - vypnout vše
      networking.useDHCP = lib.mkForce false;
      networking.dhcpcd.enable = lib.mkForce false;
      networking.networkmanager.enable = lib.mkForce false;

      systemd.services.systemd-networkd.enable = false;
      systemd.services.NetworkManager.enable = false;
      systemd.services.dhcpcd.enable = false;

      networking.interfaces = lib.mkForce {};
      networking.defaultGateway = lib.mkForce null;
      networking.nameservers = lib.mkForce [];

      # Docker - POUŽÍT mkForce PRO CELÝ ATRIBUT
      virtualisation.docker = lib.mkForce {
        enable = true;
        enableOnBoot = true;
        package = pkgs.docker_27;
        daemon.settings = {
          ip = "0.0.0.0";
        };
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

      # Firewall
      networking.firewall.enable = false;

      # SSH
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "yes";
        };
      };

      users.users.root.initialPassword = "test123";

      # Vypnout zbytečné služby
      services.resolved.enable = false;
      services.timesyncd.enable = false;

      environment.systemPackages = with pkgs; [
        vim htop curl wget git tmux docker-compose
      ];
    };
  };
}
