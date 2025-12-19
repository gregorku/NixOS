{ config, pkgs, lib, ... }:

{
  containers.server2 = {
    autoStart = true;
    privateNetwork = false;
    hostBridge = "br0";

    localAddress = "10.0.0.11/24";
    hostAddress = "10.0.0.1";

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "server2";

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

      users.users.root.initialPassword = "changeme";

      services.openssh.enable = true;
      services.openssh.settings.PermitRootLogin = "yes";
    };
  };
}
