{ config, pkgs, ... }:

{
  services.cockpit = {
      enable = true;
      port = 9090;
      allowed-origins = [
        "https://cockpit.<domain>.com"  # The public-facing URL clients will connect from in the browser
      ];
      settings = {
        WebService = {
          AllowUnencrypted = true;
          ProtocolHeader = "X-Forwarded-Proto";  # Specifies the request goes through a reverse proxy
        };
    };
  };
}
