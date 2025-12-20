{ config, pkgs, lib, ... }:

{
  containers.server1 = {
    autoStart = true;
    privateNetwork = false; # Sdílí IP adresu s hostitelem [cite: 3]

    extraFlags = [
      "--capability=all"
      "--bind=/sys/fs/cgroup"
    ];

    config = { config, pkgs, lib, ... }: {
      boot.isContainer = true;
      system.stateVersion = "24.05";

      # Zabránění konfliktu portů: Hostitel má 22, kontejner bude mít 2222 [cite: 13, 15]
      services.openssh = {
        enable = true;
        ports = [ 2222 ];
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "yes";
        };
      };

      # Síťová konfigurace pro host networking
      networking.hostName = lib.mkForce "server1"; # [cite: 3]
      networking.useDHCP = lib.mkForce false;
      networking.firewall.enable = false; # V kontejneru vypnuto [cite: 13]

      # Docker konfigurace
      virtualisation.docker = {
        enable = true;
        daemon.settings = {
          iptables = false;
          ip-forward = false;
          ip-masq = false;
        };
      };

      # Nasazení Portaineru čistou cestou přes OCI kontejnery
      virtualisation.oci-containers.backend = "docker";
      virtualisation.oci-containers.containers.portainer = {
        image = "portainer/portainer-ee:2.33.6";
        ports = [ "8443:9000" ]; # Port 8443 na hostiteli mapuje na 9000 v Dockeru
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "portainer_data:/data"
        ];
        extraOptions = [ "--name=portainer" ];
      };

      users.users.root.initialPassword = "test123";

      environment.systemPackages = with pkgs; [
        vim htop curl wget git tmux docker-compose
      ];
    };
  };
}
