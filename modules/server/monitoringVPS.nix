{ config, lib, pkgs, ... }:

{
  ############################################################
  ## Monitoring - VPS Server
  ##
  ## Exporters:
  ##   • node_exporter
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
  ## Firewall
  ############################

  networking.firewall.interfaces.wg1.allowedTCPPorts = [
    9100 # node_exporter
  ];
}