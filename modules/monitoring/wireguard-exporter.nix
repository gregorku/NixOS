{
  config,
  pkgs,
  lib,
  ...
}: let
  peers = import ../server/wireguard-peers.nix;

  mkPeer = peer: {
    publicKey = peer.publicKey;
    allowedIPs = [peer.allowedIP];
  };

  peersForInterface = interface:
    lib.mapAttrsToList
    (
      _: peer:
        mkPeer peer.${interface}
    )
    (
      lib.filterAttrs
      (_: peer: peer.${interface} or null != null)
      peers
    );

  peerNamesConfig =
    lib.concatStringsSep "\n\n"
    (
      lib.flatten
      (
        lib.mapAttrsToList
        (
          _: peer:
            lib.filter
            (block: block != null)
            [
              (
                if peer ? wg1
                then ''
                  [Peer]
                  # ${peer.name}
                  PublicKey = ${peer.wg1.publicKey}
                  AllowedIPs = ${peer.wg1.allowedIP}
                ''
                else null
              )

              (
                if peer ? wg2
                then ''
                  [Peer]
                  # ${peer.name}
                  PublicKey = ${peer.wg2.publicKey}
                  AllowedIPs = ${peer.wg2.allowedIP}
                ''
                else null
              )

              (
                if peer ? wg3
                then ''
                  [Peer]
                  # ${peer.name}
                  PublicKey = ${peer.wg3.publicKey}
                  AllowedIPs = ${peer.wg3.allowedIP}
                ''
                else null
              )
            ]
        )
        peers
      )
    );
in {
  environment.systemPackages = [
    pkgs.prometheus-wireguard-exporter
  ];

  environment.etc."prometheus-wireguard-exporter/peers.conf" = {
    text = peerNamesConfig;
    mode = "0444";
  };

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
          --extract_names_config_files /etc/prometheus-wireguard-exporter/peers.conf \
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
