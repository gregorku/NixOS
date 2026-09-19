{
  config,
  pkgs,
  lib,
  ...
}: let
  ##################################################
  # WireGuard peer metadata
  #
  # Společný zdroj názvů, veřejných klíčů a IP.
  ##################################################
  peers = import ../server/wireguard-peers.nix;

  ##################################################
  # Konfigurace pro prometheus-wireguard-exporter
  #
  # Exporter očekává:
  #
  # [Peer]
  # # jméno peeru
  # PublicKey = ...
  #
  # Proto generujeme jeden [Peer] blok pro každý
  # veřejný klíč na každém WireGuard rozhraní.
  ##################################################

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
                ''
                else null
              )

              (
                if peer ? wg2
                then ''
                  [Peer]
                  # ${peer.name}
                  PublicKey = ${peer.wg2.publicKey}
                ''
                else null
              )

              (
                if peer ? wg3
                then ''
                  [Peer]
                  # ${peer.name}
                  PublicKey = ${peer.wg3.publicKey}
                ''
                else null
              )
            ]
        )
        peers
      )
    );
in {
  ##################################################
  # WireGuard exporter package
  ##################################################

  environment.systemPackages = [
    pkgs.prometheus-wireguard-exporter
  ];

  ##################################################
  # Exporter peer names configuration
  #
  # Soubor je generovaný deklarativně z
  # wireguard-peers.nix.
  ##################################################

  environment.etc."prometheus-wireguard-exporter/peers.conf" = {
    text = peerNamesConfig;
    mode = "0444";
  };

  ##################################################
  # Prometheus WireGuard Exporter
  ##################################################

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
