{ config, lib, pkgs, ... }:

{
  ############################################################
  ## Monitoring - Physical NixOS Server
  ##
  ## Exporters:
  ##   • node_exporter
  ##   • smartctl_exporter
  ##   • zfs_exporter
  ############################################################

  ############################
  ## Node Exporter
  ############################

  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;

    enabledCollectors = [
      "cpu"
      "diskstats"
      "filesystem"
      "hwmon"
      "thermal_zone"
      "loadavg"
      "meminfo"
      "netdev"
      "os"
      "pressure"
      "stat"
      "systemd"
      "time"
      "uname"
      "vmstat"
    ];
  };

  ############################
  ## smartctl_exporter
  ############################

  environment.systemPackages = with pkgs; [
    smartmontools
    prometheus-smartctl-exporter
    prometheus-zfs-exporter
  ];

  systemd.services.prometheus-smartctl-exporter = {
    description = "Prometheus SMARTCTL Exporter";

    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5";

      ExecStart = ''
        ${pkgs.prometheus-smartctl-exporter}/bin/smartctl_exporter \
          --web.listen-address=:9633
      '';
    };
  };

  ############################
  ## ZFS Exporter
  ############################

  systemd.services.prometheus-zfs-exporter = {
    description = "Prometheus ZFS Exporter";

    after = [ "zfs.target" "network.target" ];
    wants = [ "zfs.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5";

      ExecStart = ''
        ${pkgs.prometheus-zfs-exporter}/bin/zfs_exporter \
          --web.listen-address=:9134
      '';
    };
  };

  ############################
  ## Firewall
  ############################

  networking.firewall.interfaces.wg1.allowedTCPPorts = [
    9100  # node_exporter
    9134  # zfs_exporter
    9633  # smartctl_exporter
  ];
}