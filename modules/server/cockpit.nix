{ config, pkgs, ... }:

{
  services.cockpit = {
    enable = true;
    openFirewall = true;

    settings = {
      WebService = {
        # Poslouchej i na IPv4
        ListenStream = "0.0.0.0:9090";
      };
    };
  };
}
