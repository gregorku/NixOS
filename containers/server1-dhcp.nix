{ config, pkgs, lib, ... }:

{
  containers.server1 = {
    autoStart = true;
    privateNetwork = false;  # Sdílet hostitelskou síť

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "server1";
      system.stateVersion = "25.05";

      # Povolit DHCP v kontejneru
      networking.useDHCP = true;

      # Docker
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
      };

      # Portainer Business Edition
      systemd.services.portainer = {
        description = "Portainer Business Edition";
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        serviceConfig = {
          ExecStart = ''
            ${pkgs.docker}/bin/docker run \
              --name portainer \
              --restart unless-stopped \
              -p 8443:9000 \
              -v /var/run/docker.sock:/var/run/docker.sock \
              -v portainer_data:/data \
              portainer/portainer-ee:2.33.6
          '';
          ExecStop = "${pkgs.docker}/bin/docker stop portainer";
          ExecStopPost = "${pkgs.docker}/bin/docker rm portainer";
          Restart = "on-failure";
        };
        wantedBy = [ "multi-user.target" ];
      };

      # Firewall v kontejneru
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 8443 ];

      # SSH (volitelné)
      services.openssh.enable = true;
      services.openssh.settings.PermitRootLogin = "yes";

      # Nastavit heslo pro root (pro SSH)
      users.users.root.initialPassword = "changeme";
    };
  };
}
