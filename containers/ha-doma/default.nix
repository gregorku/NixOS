{ config, pkgs, ... }:

{
  containers.ha-doma = {
    autoStart = true;

    privateNetwork = false;
    hostBridge = "br0";

    config = { config, pkgs, ... }: {
      system.stateVersion = "25.05";

      networking.hostName = "ha-doma";
      time.timeZone = "Europe/Prague";

      services.openssh.enable = true;

      users.users.root.openssh.authorizedKeys.keys = [
        # tvůj SSH public key
      ];

      environment.systemPackages = with pkgs; [
        bash
        curl
        git
        vim
        nano
        mc
      ];
    };
  };
}
