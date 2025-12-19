{ config, pkgs, lib, ... }:

{
  containers.server2 = {
    autoStart = true;
    privateNetwork = false;

    # POVINNÉ pro Docker v kontejneru
    extraFlags = [
      "--capability=all"
      "--system-call-filter=@system-service"
      "--bind=/sys/fs/cgroup"
    ];

    config = { config, pkgs, lib, ... }: {
      boot.isContainer = true;

      networking.hostName = "server2";
      system.stateVersion = "25.05";

      # Síť - vypnout vše, použije host network
      networking.useDHCP = lib.mkForce false;
      networking.dhcpcd.enable = lib.mkForce false;
      networking.networkmanager.enable = lib.mkForce false;

      systemd.services.systemd-networkd.enable = false;
      systemd.services.NetworkManager.enable = false;
      systemd.services.dhcpcd.enable = false;

      networking.interfaces = lib.mkForce {};
      networking.defaultGateway = lib.mkForce null;
      networking.nameservers = lib.mkForce [];

      # Docker konfigurace pro kontejnery
      virtualisation.docker = lib.mkForce {
        enable = true;
        enableOnBoot = true;
        package = pkgs.docker_27;
        daemon.settings = {
          ip = "0.0.0.0";
          # Důležité pro kontejnery
          exec-opts = ["native.cgroupdriver=cgroupfs"];
          storage-driver = "vfs";
        };
        extraOptions = "--exec-opt native.cgroupdriver=cgroupfs --storage-driver=vfs";
      };

      # Potřebné pro Docker v kontejneru
      boot.kernelModules = [ "overlay" ];
      boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

      # Povolit cgroups
      systemd.enableUnifiedCgroupHierarchy = false;

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
            -p 9443:9000 \
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

      services.resolved.enable = false;
      services.timesyncd.enable = false;

      environment.systemPackages = with pkgs; [
        vim htop curl wget git tmux docker-compose
      ];
    };
  };
}
