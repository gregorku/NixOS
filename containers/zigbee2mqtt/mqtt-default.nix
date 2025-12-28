{ config, pkgs, ... }:

{
  ## =========================================================
  ## SÍŤOVÁ KONFIGURACE – beze změn
  ## =========================================================
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.enable = true;
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
    dhcpV4Config.ClientIdentifier = "mac";
  };

  networking.firewall.allowedTCPPorts = [ 1883 ];

  system.stateVersion = "25.11";

  ## =========================================================
  ## MOSQUITTO – RUČNÍ SYSTEMD SERVICE
  ## =========================================================
  environment.systemPackages = [ pkgs.mosquitto ];

  environment.etc."mosquitto/mosquitto.conf".text = ''
    allow_anonymous false
    password_file /etc/mosquitto/secrets/passwd
    listener 1883 0.0.0.0
  '';

  systemd.services.mosquitto = {
    description = "Mosquitto MQTT broker";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.mosquitto}/bin/mosquitto -c /etc/mosquitto/mosquitto.conf";
      Restart = "always";
      User = "root";
      Group = "root";

      # 🔑 Povolit přístup k secrets mountu
      ProtectSystem = "off";
      ProtectHome = false;
      ReadOnlyPaths = [ "/etc/mosquitto/secrets" ];
    };
  };
}
