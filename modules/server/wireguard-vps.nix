{ config, pkgs, lib, ... }:

{
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

    wg1 = {
      ips = [ "10.100.100.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wg1_serverVPS-private.path;

      peers = [
        {
          # Mikrotik doma wg1
          publicKey = "ZRRN9IVqc8atE1Cby4k00YKe0bd74N7/bscvkIybKyk=";
          allowedIPs = [ "10.100.100.100/32" ];
        }
      ];
    };

    wg2 = {
      ips = [ "10.110.100.1/24" ];
      listenPort = 51821;
      privateKeyFile = config.age.secrets.wg2_serverVPS-private.path;

      peers = [
        {
          # (doplníš peer wg2)
          publicKey = "";
          allowedIPs = [ ];
        }
      ];
    };

    wg3 = {
      ips = [ "10.120.100.1/24" ];
      listenPort = 51822;
      privateKeyFile = config.age.secrets.wg3_serverVPS-private.path;

      peers = [
        {
          # (doplníš peer wg3)
          publicKey = "";
          allowedIPs = [ ];
        }
      ];
    };

  };
}