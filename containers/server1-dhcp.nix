{ config, pkgs, lib, ... }:

{
  containers.server1 = {
    autoStart = true;
    privateNetwork = false;

    # Pro Docker v kontejneru potřebujeme bind mount cgroups a některé další
    extraFlags = [
      "--capability=all"
      "--bind=/sys/fs/cgroup"
    ];

    config = { config, pkgs, lib, ... }: {
      boot.isContainer = true;

      # Použijte mkForce pro přepsání vnitřních definic
      networking.hostName = lib.mkForce "server1";
      system.stateVersion = "25.05";

      # Síť: kontejner používá host networking, takže nic nenastavujeme
      networking.useDHCP = lib.mkForce false;
      networking.dhcpcd.enable = lib.mkForce false;
      networking.networkmanager.enable = lib.mkForce false;
      networking.interfaces = lib.mkForce {};

      # Docker: vypněte iptables, protože v kontejneru nemáme potřebná oprávnění
      virtualisation.docker = lib.mkForce {
        enable = true;
        enableOnBoot = true;
        package = pkgs.docker_27;
        daemon.settings = {
          iptables = false;
          ip-forward = false;
          ip-masq = false;
        };
        extraOptions = "--iptables=false --ip-forward=false --ip-masq=false";
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
          Restart = "on-failure";
          RestartSec = "10s";
          TimeoutStartSec = "300";
        };
        wantedBy = [ "multi-user.target" ];
      };

      # SSH pro přístup do kontejneru
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "yes";
        };
      };

      users.users.root.initialPassword = "test123";

      # Vypněte zbytečné služby
      services.resolved.enable = false;
      services.timesyncd.enable = false;

      environment.systemPackages = with pkgs; [
        vim htop curl wget git tmux docker-compose
      ];
    };
  };
}
