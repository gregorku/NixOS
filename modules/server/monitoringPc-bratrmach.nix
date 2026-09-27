{
  config,
  lib,
  pkgs,
  ...
}: {
  ############################################################
  ## Monitoring - Physical NixOS Server
  ##
  ## Exporters:
  ##   • node_exporter
  ##   • smartctl_exporter
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
  ];

  systemd.services.prometheus-smartctl-exporter = {
    description = "Prometheus SMARTCTL Exporter";

    after = ["network.target"];
    wantedBy = ["multi-user.target"];

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
  ## Firewall
  ############################

  networking.firewall.interfaces.wg3.allowedTCPPorts = [
    9100 # node_exporter
    9633 # smartctl_exporter
  ];
}
