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

        # WireGuard (wg1, wg2, wg3)
        udp dport { 53820, 53821, 53822 } accept;

        # Cockpit
        tcp dport 9090 ip saddr @trusted accept;
        tcp dport 9090 iifname "wg1" accept;

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
        iifname { "wg1", "wg2", "wg3" } accept;
        oifname { "wg1", "wg2", "wg3" } accept;

        # DNAT traffic
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

        # ---- WireGuard wg1 ----
        iifname "wg1" tcp dport 19443 dnat to 200.1.1.100:9443
        iifname "wg1" tcp dport 19444 dnat to 200.1.1.110:9443
        iifname "wg1" tcp dport 19447 dnat to 200.1.1.111:9443
        iifname "wg1" tcp dport 8887  dnat to 200.1.1.200:8887
        iifname "wg1" tcp dport 8888  dnat to 200.1.1.200:8888
        iifname "wg1" tcp dport 8889  dnat to 200.1.1.200:8889
        iifname "wg1" tcp dport 12022 dnat to 200.1.1.200:22
        iifname "wg1" tcp dport 19200 dnat to 200.1.1.200:9443
        iifname "wg1" tcp dport 19446 dnat to 200.1.1.120:9443
        iifname "wg1" tcp dport 3001  dnat to 200.1.1.110:3001
        iifname "wg1" tcp dport 8080  dnat to 200.1.1.110:8080
        iifname "wg1" tcp dport 9090  dnat to 200.1.1.111:9090
        iifname "wg1" tcp dport 9091  dnat to 200.1.1.171:9090

        # ---- WireGuard wg3 ----
        iifname "wg3" tcp dport 10051 dnat to 200.1.1.111:10051

        # ---- Public interface (ens3) ----
        iifname "ens3" tcp dport 8182 dnat to 10.110.100.220:8182
        iifname "ens3" tcp dport 5541 dnat to 10.110.100.220:5541
        iifname "ens3" tcp dport 8181 dnat to 10.110.100.210:8181
        iifname "ens3" tcp dport 5540 dnat to 10.110.100.210:5540
        iifname "ens3" tcp dport 8000 dnat to 10.110.100.200:8000
      }

      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;

        # NAT Incus
        ip saddr 10.10.10.0/24 oifname "ens3" masquerade;

        # NAT WireGuard
        ip saddr 10.100.100.0/24 oifname "ens3" masquerade;
        ip saddr 10.110.100.0/24 oifname "ens3" masquerade;
        ip saddr 10.120.100.0/24 oifname "ens3" masquerade;
      }
    }
  '';

  environment.systemPackages = with pkgs; [ nftables ];
}