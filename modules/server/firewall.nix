{ config, pkgs, lib, ... }:

{
  # Použití nftables místo starého iptables
  networking.nftables.enable = true;
  networking.firewall.enable = false; # vlastní ruleset

  networking.nftables.ruleset = ''
    table inet filter {

      #------------------------------------------------------------------
      # Sady (sets) pro správu IP adres
      #------------------------------------------------------------------
      set trusted_ips {
        type ipv4_addr
        flags interval
        elements = {
          # 1.2.3.4/32,
        }
      }

      #------------------------------------------------------------------
      # INPUT – příchozí provoz
      #------------------------------------------------------------------
      chain input {
        type filter hook input priority filter; policy drop;

        ct state established,related accept
        iifname lo accept

        # ICMP
        ip protocol icmp accept
        ip6 nexthdr icmpv6 accept

        # Incus kontejnery → host
        iifname "incusbr0" accept

        # SSH
        tcp dport 22 accept

        # HTTP/HTTPS
        tcp dport { 80, 443 } accept

        # WireGuard
        udp dport 51820 accept

        # Cockpit
        tcp dport 9090 ip saddr @trusted_ips accept

        # HAProxy stats
        tcp dport 8404 ip saddr @trusted_ips accept

        # HAProxy TCP
        tcp dport 8443 accept

        log prefix "DROPPED INPUT: " flags all limit rate 5/minute
        drop
      }

      #------------------------------------------------------------------
      # FORWARD – provoz přes server (Incus)
      #------------------------------------------------------------------
      chain forward {
        type filter hook forward priority filter; policy drop;

        ct state established,related accept

        # Incus → ven
        iifname "incusbr0" oifname != "incusbr0" accept

        # ven → Incus (jen odpovědi)
        iifname != "incusbr0" oifname "incusbr0" ct state established,related accept

        # WireGuard
        iifname "wg0" accept
        oifname "wg0" accept

        # DNAT (port forwarding)
        ct status dnat accept

        log prefix "DROPPED FORWARD: " flags all limit rate 5/minute
        drop
      }

      #------------------------------------------------------------------
      # OUTPUT – odchozí provoz
      #------------------------------------------------------------------
      chain output {
        type filter hook output priority filter; policy accept;
      }
    }

    #------------------------------------------------------------------
    # NAT
    #------------------------------------------------------------------
    table inet nat {

      chain prerouting {
        type nat hook prerouting priority dstnat; policy accept;

        # příklady:
        # tcp dport 8080 dnat to 10.10.10.10:80
      }

      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;

        # Incus NAT (bez závislosti na eth0!)
        ip saddr 10.10.10.0/24 oifname != "incusbr0" masquerade

        # WireGuard NAT
        ip saddr 10.100.0.0/24 oifname != "wg0" masquerade
      }
    }
  '';

  environment.systemPackages = with pkgs; [
    nftables
  ];
}