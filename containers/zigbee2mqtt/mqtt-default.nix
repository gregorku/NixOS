{ config, pkgs, ... }:

{
  containers.mosquitto = {
    autoStart = true;              # Start on boot
    privateNetwork = false;        # Share host network (simplest; change to true for isolation)
    # If privateNetwork = true, add:
    # hostAddress = "192.168.100.1";
    # localAddress = "192.168.100.2";

    config = { config, pkgs, ... }: {
      services.mosquitto = {
        enable = true;
        listeners = [
          {
            address = "0.0.0.0";
            port = 1883;
            allowAnonymous = true;  # Adjust as needed
          }
        ];
      };

      networking.firewall.allowedTCPPorts = [ 1883 ];

      system.stateVersion = "25.05";  # Match your host's version or recent stable
    };
  };

  # If privateNetwork = true on container, forward port from host:
  # networking.nat.enable = true;
  # networking.nat.internalInterfaces = ["ve-mosquitto"];
  # networking.nat.externalInterface = "br0";  # Your external interface
}