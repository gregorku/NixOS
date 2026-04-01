{ config, pkgs, lib, ... }:
{
  networking.nftables.enable  = true;
  networking.firewall.enable  = false;

  networking.nftables.ruleset = ''
    table inet filter {

      set trusted {
        type ipv4_addr;
        flags interval;
        elements = {
          127.0.0.1/32
        };
      }

      chain input {
        type filter hook input priority filter; policy drop;

        ct state established,related accept;
        iifname lo accept;
        ip protocol icmp accept;
        ip6 nexthdr icmpv6 accept;

        # SSH
        tcp dport 22 accept;

        # Web
        tcp dport { 80, 443 } accept;

        # WireGuard
        udp dport 51820 accept;

        # Cockpit
        tcp dport 9090 ip saddr @trusted accept;
        tcp dport 9090 iifname "wg0" accept;

        # HAProxy stats
        tcp dport 8404 ip saddr @trusted accept;

        # HAProxy TCP
        tcp dport 8443 accept;

        # Logging
        limit rate 5/minute log prefix "FW DROP IN: ";
        drop;
      }

      chain forward {
        type filter hook forward priority filter; policy drop;

        ct state established,related accept;

        # Incus
        iifname "incusbr0" accept;
        oifname "incusbr0" accept;

        # WireGuard
        iifname "wg0" accept;
        oifname "wg0" accept;

        # DNAT
        ct status dnat accept;

        limit rate 5/minute log prefix "FW DROP FWD: ";
        drop;
      }

      chain output {
        type filter hook output priority filter; policy accept;
      }
    }

    table inet nat {

      chain prerouting {
        type nat hook prerouting priority dstnat; policy accept;
      }

      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;

        # NAT Incus
        ip saddr 10.10.10.0/24 oifname "ens3" masquerade;

        # NAT WireGuard
        ip saddr 10.100.0.0/24 oifname "ens3" masquerade;
      }
    }
  '';

  environment.systemPackages = with pkgs; [ nftables ];
}