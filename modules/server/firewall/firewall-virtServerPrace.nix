{ config, pkgs, lib, ... }:

let
  dnat = import ./dnat-virtPc.nix;
  # generátor jednoho DNAT pravidla
  genRule = iface: r:
    ''iifname "${iface}" tcp dport ${toString r.port} dnat ip to ${r.target}'';
  # veřejné DNAT porty z ens3
  publicRules = map (r: genRule "ens3" r) dnat.public;
  allDnatRules =
    lib.concatStringsSep "\n" publicRules;

in
{
  networking.nftables.enable = true;
  networking.firewall.enable = false;

  networking.nftables.ruleset = ''
    table inet filter {

      set trusted {
        type ipv4_addr;
        flags interval;
        elements = {
          127.0.0.1/32,
          10.100.100.0/24,
          10.110.100.0/24,
          10.120.100.0/24
        };
      }

      chain input {
        type filter hook input priority filter;
        policy drop;

        # existující spojení
        ct state established,related accept;
        # localhost
        iifname lo accept;
        # ping
        ip protocol icmp accept;
        ip6 nexthdr icmpv6 accept;
        # SSH
        tcp dport 22 accept;
        # HTTP / HTTPS
        tcp dport { 80, 443 } accept;
        # Cockpit pouze z trusted IP
        tcp dport 9090 ip saddr @trusted accept;
        # HAProxy stats pouze z trusted IP
        tcp dport 8404 ip saddr @trusted accept;
        # Incus API pouze z br0
        iifname "br0" tcp dport 8443 accept;

        # ───────────────────────────────
        # porty monitors (musí být před finálním drop)
        # ───────────────────────────────
        tcp dport { 9100, 9134, 9633 } ip saddr @trusted accept;

        # logování zahazovaných paketů
        limit rate 5/minute log prefix "FW DROP IN: ";
        drop;
      }

      chain forward {
        type filter hook forward priority filter;
        policy drop;

        # navázaná spojení
        ct state established,related accept;
        # provoz z/do Incus bridge
        iifname "incusbr0" accept;
        oifname "incusbr0" accept;
        # Incus kontejnery přímo v LAN přes br0
        iifname "br0" oifname "br0" accept;
        # přesměrované (DNAT) spojení
        ct status dnat accept;
        # logování
        limit rate 5/minute log prefix "FW DROP FWD: ";
        drop;
      }

      chain output {
        type filter hook output priority filter;
        policy accept;
      }
    }

    table inet nat {

      chain prerouting {
        type nat hook prerouting priority dstnat;
        policy accept;

        ${allDnatRules}
      }

      # POSTROUTING schválně vynechán.
      # NAT pro síť 10.10.10.0/24 vytváří Incus automaticky
      # díky:
      #
      # ipv4.address = 10.10.10.1/24
      # ipv4.nat     = true
      #
      # v konfiguraci sítě incusbr0.
    }
  '';

  environment.systemPackages = with pkgs; [
    nftables
  ];
}