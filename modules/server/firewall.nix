{ config, pkgs, lib, ... }:
{
  # Použití nftables místo starého iptables
  networking.nftables.enable = true;
  networking.firewall.enable = false; # vypnout NixOS wrapper, použijeme vlastní nftables

  networking.nftables.ruleset = ''
    table inet filter {

      #------------------------------------------------------------------
      # Sady (sets) pro správu IP adres
      #------------------------------------------------------------------
      set trusted_ips {
        type ipv4_addr
        flags interval
        elements = {
          # Vaše domácí/kancelářská IP – přidejte sem
          # 1.2.3.4/32,
        }
      }

      #------------------------------------------------------------------
      # Chain: INPUT – příchozí provoz na server
      #------------------------------------------------------------------
      chain input {
        type filter hook input priority filter; policy drop;

        # Povolení navázaných/related spojení
        ct state established,related accept

        # Loopback vždy povolen
        iifname lo accept

        # ICMP – ping povolen
        ip protocol icmp accept
        ip6 nexthdr icmpv6 accept

        # SSH – pouze z trusted IP nebo všem (vyberte variantu)
        # Varianta A: SSH odkudkoli (pokud máte jen klíče, je to OK)
        tcp dport 22 accept
        # Varianta B: SSH pouze z trusted IP (bezpečnější)
        # tcp dport 22 ip saddr @trusted_ips accept

        # HTTP/HTTPS – pro HAProxy
        tcp dport { 80, 443 } accept

        # WireGuard VPN
        udp dport 51820 accept

        # Cockpit (přes HAProxy, ale i přímý přístup)
        tcp dport 9090 ip saddr @trusted_ips accept

        # HAProxy statistiky – pouze z trusted IP
        tcp dport 8404 ip saddr @trusted_ips accept

        # HAProxy TCP frontend
        tcp dport 8443 accept

        # Zamítnutí ostatního s logováním
        log prefix "DROPPED INPUT: " flags all limit rate 5/minute
        drop
      }

      #------------------------------------------------------------------
      # Chain: FORWARD – přesměrovaný provoz (pro Incus kontejnery)
      #------------------------------------------------------------------
      chain forward {
        type filter hook forward priority filter; policy drop;

        # Navázaná/related spojení
        ct state established,related accept

        # Provoz z/do Incus bridge sítě
        iifname "incusbr0" accept
        oifname "incusbr0" accept

        # Provoz přes WireGuard
        iifname "wg0" accept
        oifname "wg0" accept

        # Port forwarding do kontejnerů – povolení forwardu
        # (konkrétní pravidla jsou v tabulce nat níže)
        ct status dnat accept

        log prefix "DROPPED FORWARD: " flags all limit rate 5/minute
        drop
      }

      #------------------------------------------------------------------
      # Chain: OUTPUT – odchozí provoz ze serveru
      #------------------------------------------------------------------
      chain output {
        type filter hook output priority filter; policy accept;
        # Výchozí: vše povoleno (server může komunikovat ven)
        # Zpřísnění dle potřeby
      }
    }

    #------------------------------------------------------------------
    # NAT tabulka – masquerade a port forwarding
    #------------------------------------------------------------------
    table inet nat {

      chain prerouting {
        type nat hook prerouting priority dstnat; policy accept;

        #--------------------------------------------------------------
        # PORT FORWARDING do Incus kontejnerů
        # Příklady – odkomentujte a upravte dle potřeby
        #--------------------------------------------------------------

        # HTTP na kontejner app1 (10.10.10.10)
        # tcp dport 8080 dnat to 10.10.10.10:80

        # SSH na kontejner server1 (10.10.10.11)
        # tcp dport 2222 dnat to 10.10.10.11:22

        # Databáze na kontejner db1 (10.10.10.12)
        # tcp dport 5432 ip daddr VPS_PUBLIC_IP dnat to 10.10.10.12:5432
      }

      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;

        # Masquerade pro Incus kontejnery (přístup kontejnerů na internet)
        ip saddr 10.10.10.0/24 oifname "eth0" masquerade

        # Masquerade pro WireGuard klienty
        ip saddr 10.100.0.0/24 oifname "eth0" masquerade
      }
    }
  '';

  # Balíčky pro správu firewallu
  environment.systemPackages = with pkgs; [
    nftables  # nft příkaz
  ];
}