{ config, pkgs, lib, ... }:

{
  ## =========================
  ## COCKPIT
  ## =========================
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

  ## =========================
  ## PODMAN
  ## =========================
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Zajistí správnou funkci DNS v kontejnerech
      dns_enabled = true;
    };
  };

  ## Podman socket pro komunikaci s Cockpit
  systemd.sockets.podman = {
    enable = true;
    description = "Podman socket";
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = "/run/podman/podman.sock";
      SocketMode = "0660";
      SocketUser = "root";
      SocketGroup = "podman"; # nebo "docker" pokud používáte dockerCompat
    };
  };

  ## Socket pro Cockpit
  systemd.sockets.cockpit.socketConfig.ListenStream =
    lib.mkForce [ "0.0.0.0:9090" ];

  ## =========================
  ## OPRÁVNĚNÍ
  ## =========================
  security.polkit.enable = true;

  ## =========================
  ## UŽIVATELÉ A SKUPINY
  ## =========================
  # Pokud chcete, aby jiní uživatelé mohli spravovat kontejnery
  users.users.<vaše-username>.extraGroups = [ "podman" ];
}
