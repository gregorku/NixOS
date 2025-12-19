{ config, pkgs, lib, ... }:

{
  containers.server1 = {
    autoStart = true;
    privateNetwork = false;  # Host networking

    extraFlags = [
      "--bind=/tmp"
      "--bind=/run"
    ];

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "server1";
      system.stateVersion = "25.05";

      # ŘEŠENÍ KONFLIKTU: explicitně nastavit DHCP s vysokou prioritou
      networking.useDHCP = lib.mkForce true;
      # Vypnout NetworkManager v kontejneru, protože používáme host network
      networking.networkmanager.enable = lib.mkForce false;

      # Explicitně zakázat další služby, které by mohly konfliktovat
      networking.dhcpcd.enable = lib.mkForce false;
      networking.interfaces = lib.mkForce {};

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

      # Firewall
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 8443 ];

      # SSH
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "yes";
        };
      };

      users.users.root.initialPassword = "test123";

      environment.systemPackages = with pkgs; [
        vim htop curl wget git tmux docker-compose
      ];
    };
  };
}
