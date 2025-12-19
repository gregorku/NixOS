{ config, pkgs, lib, ... }:

{
  containers.server2 = {
    autoStart = true;
    privateNetwork = false;  # Sdílet hostitelskou síť

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "server2";
      system.stateVersion = "25.05";

      # Povolit DHCP v kontejneru
      networking.useDHCP = true;

      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
      };

      systemd.services.portainer = {
        description = "Portainer Business Edition";
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        serviceConfig = {
          ExecStart = ''
            ${pkgs.docker}/bin/docker run \
              --name portainer \
              --restart unless-stopped \
              -p 9443:9000 \
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

      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 9443 ];

      services.openssh.enable = true;
      services.openssh.settings.PermitRootLogin = "yes";
      users.users.root.initialPassword = "changeme";
    };
  };
}
