{
  config,
  pkgs,
  lib,
  ...
}: let
  ##################################################
  # WireGuard peers
  #
  # Seznam peerů je uložen samostatně v:
  # ./wireguard-peers.nix
  #
  # Tento soubor obsahuje jména, veřejné klíče
  # a allowed IP jednotlivých klientů.
  ##################################################
  peers = import ./wireguard-peers.nix;

  ##################################################
  # Převod našeho seznamu do formátu NixOS
  ##################################################

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
in {
  ##################################################
  # AGENIX secrets
  ##################################################

  age.secrets.wg1_serverVPS-private.file =
    ../../VPSsecret/wireguard/wg1_serverVPS-private.age;

  age.secrets.wg2_serverVPS-private.file =
    ../../VPSsecret/wireguard/wg2_serverVPS-private.age;

  age.secrets.wg3_serverVPS-private.file =
    ../../VPSsecret/wireguard/wg3_serverVPS-private.age;

  ##################################################
  # WireGuard
  ##################################################

  networking.wireguard.interfaces = {
    ##################################################
    # WG1
    ##################################################

    wg1 = {
      ips = ["10.100.100.1/24"];
      listenPort = 53820;
      privateKeyFile = config.age.secrets.wg1_serverVPS-private.path;

      peers = peersForInterface "wg1";
    };

    ##################################################
    # WG2
    ##################################################

    wg2 = {
      ips = ["10.110.100.1/24"];
      listenPort = 53821;
      privateKeyFile = config.age.secrets.wg2_serverVPS-private.path;

      peers = peersForInterface "wg2";
    };

    ##################################################
    # WG3
    ##################################################

    wg3 = {
      ips = ["10.120.100.1/24"];
      listenPort = 53822;
      privateKeyFile = config.age.secrets.wg3_serverVPS-private.path;

      peers = peersForInterface "wg3";
    };
  };
}
