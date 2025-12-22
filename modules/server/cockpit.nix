{ config, pkgs, lib, ... }:

{
  ## =========================
  ## COCKPIT
  ## =========================
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

  ## Cockpit plugin pro Podman
  environment.systemPackages = with pkgs; [
    cockpit-podman
  ];

  ## =========================
  ## PODMAN
  ## =========================
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  ## Podman socket (nutné pro Cockpit)
  systemd.services.podman.enable = true;
  systemd.sockets.podman.enable = true;

  ## =========================
  ## NETWORK / SOCKET
  ## =========================
  systemd.sockets.cockpit.socketConfig.ListenStream =
    lib.mkForce [ "0.0.0.0:9090" ];

  ## =========================
  ## OPRÁVNĚNÍ
  ## =========================
  security.polkit.enable = true;
}
