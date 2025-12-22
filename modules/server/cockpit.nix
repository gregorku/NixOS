{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;

    # Přidání podman pluginu
    extraPackages = [ pkgs.cockpitPlugins.podman ];

    settings = {
      WebService = {
        AllowUnencrypted = true;
        Origins = lib.mkForce "*";
      };
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  systemd.services.podman.enable = true;
  systemd.sockets.podman.enable = true;

  systemd.sockets.cockpit.socketConfig.ListenStream =
    lib.mkForce [ "0.0.0.0:9090" ];

  security.polkit.enable = true;
}
