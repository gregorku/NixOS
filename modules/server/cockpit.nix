{ config, pkgs, lib, ... }:

{
  # 1. POVOLENÍ PCP
  services.pcp = {
    enable = true;
    # režim "standalone" = pmcd + pmlogger + pmie + pmproxy [citation:1]
    presets = "standalone"; 
  };

  # 2. KONFIGURACE COCKPITU
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
