{ config, pkgs, lib, ... }:

{
  containers.server1 = {
    autoStart = true;
    privateNetwork = false;

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "server1";
      system.stateVersion = "25.05";

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

      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 8443 ];

      users.users.root.initialPassword = "changeme";

      services.openssh.enable = true;
      services.openssh.settings.PermitRootLogin = "yes";
    };
  };
}
