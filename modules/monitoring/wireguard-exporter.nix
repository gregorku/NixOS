{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.prometheus-wireguard-exporter
  ];

  systemd.services.prometheus-wireguard-exporter = {
    description = "Prometheus WireGuard Exporter";

    after = [
      "network.target"
      "wireguard-wg1.service"
      "wireguard-wg2.service"
      "wireguard-wg3.service"
    ];

    wants = [
      "wireguard-wg1.service"
      "wireguard-wg2.service"
      "wireguard-wg3.service"
    ];

    wantedBy = [
      "multi-user.target"
    ];

    serviceConfig = {
      Type = "simple";

      Environment = [
        "PATH=${pkgs.wireguard-tools}/bin"
      ];

      ExecStart = ''
        ${pkgs.prometheus-wireguard-exporter}/bin/prometheus_wireguard_exporter \
          --address 10.10.10.1 \
          --port 9586 \
          --interfaces wg1 wg2 wg3 \
          --export_remote_ip_and_port true \
          --export_latest_handshake_delay true
      '';

      Restart = "on-failure";
      RestartSec = "5s";

      DynamicUser = true;
      CapabilityBoundingSet = ["CAP_NET_ADMIN"];
      AmbientCapabilities = ["CAP_NET_ADMIN"];

      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
    };
  };
}
