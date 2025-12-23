{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;

    settings = {
      WebService = {
        AllowUnencrypted = true;
        Origins = lib.mkForce "*";
      };
    };
  };

  # Vynucení poslouchání POUZE na IPv4 (0.0.0.0:9090)
  systemd.sockets.cockpit.socketConfig = {
    ListenStream = lib.mkForce [ "0.0.0.0:9090" ];
  };

  security.polkit.enable = true;
}
