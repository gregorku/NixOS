{ config, pkgs, ... }:

{
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

  networking.firewall.allowedTCPPorts = [ 5000 1935 ];

  system.stateVersion = "25.11";

  users.groups.frigate = {};
  users.users.frigate = {
    isSystemUser = true;
    group = "frigate";
    home = "/data/frigate";
  };

  environment.systemPackages = with pkgs; [ frigate ffmpeg ];

  systemd.targets.multi-user.enable = true;
  systemd.defaultUnit = "multi-user.target";

  systemd.services.frigate = {
    description = "Frigate NVR";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.frigate}/bin/frigate -c /data/frigate/config/config.yml";
      Restart = "always";
      User = "frigate";
      Group = "frigate";
      WorkingDirectory = "/data/frigate";
    };
  };
}
