{ config, pkgs, lib, ... }:
{
  # WireGuard VPN server
  networking.wireguard.interfaces.wg0 = {
    # Port pro WireGuard
    listenPort = 51820;
    
    # Privátní klíč – NIKDY nedávejte do gitu!
    # Generování: wg genkey | tee /etc/wireguard/private.key | wg pubkey > /etc/wireguard/public.key
    privateKeyFile = "/etc/wireguard/private.key";

    # IP adresa VPN serveru
    ips = [ "10.100.0.1/24" ];

    # Routing – povolení forwardingu přes WireGuard
    postSetup = ''
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -o wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    '';
    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -D FORWARD -o wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    '';

    # Peers – klienti VPN
    peers = [
      # Příklad klienta – upravte dle skutečnosti
      # {
      #   publicKey = "klientův-veřejný-klíč==";
      #   allowedIPs = [ "10.100.0.2/32" ];
      #   # persistentKeepalive = 25; # pokud je klient za NAT
      # }
    ];
  };

  # Potřebné balíčky
  environment.systemPackages = with pkgs; [
    wireguard-tools  # wg, wg-quick
  ];
}