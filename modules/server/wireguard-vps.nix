{ config, pkgs, lib, ... }:

{
  ##################################################
  # AGENIX secrets
  ##################################################
  age.secrets.wg1_serverVPS-private.file =
    ../../VPSsecret/wireguard/wg1_serverVPS-private.age;

  ##################################################
  # WireGuard
  ##################################################
  networking.wireguard.interfaces = {

    wg1 = {
      ips = [ "10.100.100.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wg1_serverVPS-private.path;

      peers = [
        {
          # Mikrotik doma wg1
          publicKey = "ZRRN9IVqc8atE1Cby4k00YKe0bd74N7/TkKZkIybKyk=";
          allowedIPs = [ "10.100.100.100/32" ];
        }
      ];
    };

  };
}