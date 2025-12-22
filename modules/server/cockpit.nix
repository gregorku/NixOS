{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;

    # Zkuste bez explicitního přidávání podman pluginu, možná je již integrován
    # Pokud ne, zkuste přidat přes extraPackages
    # extraPackages = [ pkgs.cockpitPlugins.podman ]; # Toto možná neexistuje

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
