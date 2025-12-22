{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    # Na hostiteli je dobré firewall povolit, pokud ho používáte
    openFirewall = true;

    settings = {
      WebService = {
        AllowUnencrypted = true;
        Origins = lib.mkForce "*";
      };
    };
  };

  # Na hostitelském NixOS obvykle standardní socket funguje bez extra konfigurace,
  # ale pokud chcete mít jistotu IPv4 přístupu:
  systemd.sockets.cockpit.socketConfig.ListenStream = lib.mkForce [ "0.0.0.0:9090" ];
}
