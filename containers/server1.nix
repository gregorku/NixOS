{ config, pkgs, lib, ... }:

{
  containers.server1 = {
    autoStart = true;
    privateNetwork = false;
    hostBridge = "br0";

    # Fixní IP adresa
    localAddress = "10.0.0.10/24";
    hostAddress = "10.0.0.1";

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "server1";

      # Docker
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        # Můžete specifikovat verzi, ale v NixOS obvykle necháváme default
        # package = pkgs.docker;
      };

      # Služba Portainer Business Edition
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

      # Otevřít port 8443 ve firewallu kontejneru
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 8443 ];

      # Nastavit heslo pro root, aby bylo možné se přihlásit přes SSH (volitelné)
      users.users.root.initialPassword = "changeme";

      # Povolit SSH (pro přístup do kontejneru)
      services.openssh.enable = true;
      services.openssh.settings.PermitRootLogin = "yes";
    };
  };
}
