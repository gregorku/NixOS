{ config, pkgs, lib, ... }:

{
  ## =========================
  ## COCKPIT
  ## =========================
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;

    # V NixOS 24.05 se podman plugin přidává zde, ne jako samostatný balíček
    package = pkgs.cockpit.override {
      extraPlugins = with pkgs.cockpitPlugins; [
        podman
      ];
    };

    settings = {
      WebService = {
        AllowUnencrypted = true;
        Origins = lib.mkForce "*";
      };
    };
  };

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
