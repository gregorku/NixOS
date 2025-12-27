{ config, pkgs, ... }:

{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "0.0.0.0";  # Listen on all interfaces (default is localhost only for security)
        port = 1883;          # Standard MQTT port
        allowAnonymous = true;  # For testing; disable in production
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 1883 ];  # Open port if firewall is enabled
}