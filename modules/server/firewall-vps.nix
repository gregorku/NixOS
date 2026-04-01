{ config, pkgs, lib, ... }:
{
  # nftables nahrazuje iptables – modernější, přehlednější
  networking.nftables.enable  = true;
  networking.firewall.enable  = false; # vlastní pravidla níže

  networking.nftables.ruleset = ''
    table inet filter {

      # Trusted IP adresy (vaše domácí/kancelářská IP)
      set trusted {
        type ipv4_addr;
        flags interval;
        elements = {
          # 1.2.3.4/32   # <- doplňte svou IP
        }
      }

      chain input {
        type filter hook input priority filter; policy drop;

        ct state established,related accept
        iifname lo accept
        ip  protocol icmp   accept
        ip6 nexthdr  icmpv6 accept

        # SSH – odkudkoli (máte klíče, hesla vypnuta)
        tcp dport 22 accept

        # Web (HAProxy)
        tcp dport { 80, 443 } accept

        # WireGuard
        udp dport 51820 accept

        # Cockpit – pouze z trusted IP nebo přes WireGuard
        tcp dport 9090 ip saddr @trusted accept
        tcp dport 9090 iifname "wg0" accept

        # HAProxy statistiky – pouze trusted
        tcp dport 8404 ip saddr @trusted accept

        # HAProxy TCP frontend
        tcp dport 8443 accept

        # Logování zahozených paketů (rate limited)
        limit rate 5/minute log prefix "FW DROP IN: "
        drop
      }

      chain forward {
        type filter hook forward priority filter; policy drop;

        ct state established,related accept

        # Incus kontejnery
        iifname "incusbr0" accept
        oifname "incusbr0" accept

        # WireGuard
        iifname "wg0" accept
        oifname "wg0" accept

        # DNAT forwarding (port forwarding níže)
        ct status dnat accept

        limit rate 5/minute log prefix "FW DROP FWD: "
        drop
      }

      chain output {
        type filter hook output priority filter; policy accept;
      }
    }

    table inet nat {

      chain prerouting {
        type nat hook prerouting priority dstnat; policy accept;

        #----------------------------------------------------------
        # PORT FORWARDING do Incus kontejnerů
        # Odkomentujte a upravte dle potřeby
        #----------------------------------------------------------

        # HTTP na kontejner app1
        # tcp dport 8080 dnat to 10.10.10.10:80

        # SSH na kontejner server1 (přes port 2222)
        # tcp dport 2222 dnat to 10.10.10.11:22

        # PostgreSQL na kontejner db
        # tcp dport 5432 dnat to 10.10.10.12:5432
      }

      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;

        # NAT pro Incus kontejnery → internet
        ip saddr 10.10.10.0/24 oifname "ens3" masquerade

        # NAT pro WireGuard klienty → internet
        ip saddr 10.100.0.0/24 oifname "ens3" masquerade
      }
    }
  '';

  environment.systemPackages = with pkgs; [ nftables ];
}