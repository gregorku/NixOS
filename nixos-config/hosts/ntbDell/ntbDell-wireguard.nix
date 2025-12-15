{ config, pkgs, ... }:

{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.20/32" ];
    privateKeyFile = "/etc/wireguard/wg0.key";

    peers = [
      {
        publicKey = "SERVER_PUBLIC_KEY";
        endpoint = "vpn.example.com:51820";
        allowedIPs = [ "0.0.0.0/0" ];
        persistentKeepalive = 25;
      }
    ];
  };
}
