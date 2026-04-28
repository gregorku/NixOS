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

  systemd.sockets.cockpit.socketConfig = {
    ListenStream = lib.mkForce [ "0.0.0.0:9090" ];
  };

  security.polkit.enable = true;

  ############################################################
  # 📦 Pluginy a nástroje pro lepší přehled
  ############################################################
  environment.systemPackages = with pkgs; [
    # základní nástroje, které Cockpit využívá
    htop
    iotop
    lm_sensors
  ];

  # senzory (teploty atd.)
  hardware.sensor.iio.enable = true;
}