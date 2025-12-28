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

  ## ---------------------------------------------------------
  ## Uživatel mosquitto
  ## ---------------------------------------------------------
  users.groups.mosquitto = {};
  users.users.mosquitto = {
    isSystemUser = true;
    group = "mosquitto";
  };

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
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart =
      "${pkgs.mosquitto}/bin/mosquitto -c /etc/mosquitto/mosquitto.conf";
    };
}
