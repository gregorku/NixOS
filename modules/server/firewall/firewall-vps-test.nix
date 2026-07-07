{ config, pkgs, lib, ... }:

let
  dnat = import ./dnat-test.nix;

  # generátor jednoho DNAT pravidla
  genRule = iface: r:
    ''iifname "${iface}" tcp dport ${toString r.port} dnat ip to ${r.target}'';

  # WireGuard pravidla
  genWG =
    lib.mapAttrsToList (iface: rules:
      map (r: genRule iface r) rules
    ) dnat.wireguard;

  wgRules = lib.flatten genWG;

  # Public interface (ens3)
  publicRules = map (r: genRule "ens3" r) dnat.public;

  # všechna DNAT pravidla
  allDnatRules =
    lib.concatStringsSep "\n" (wgRules ++ publicRules);

in
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

        # Incus bridge – DHCP a DNS
        iifname "incusbr0" udp dport 67 accept;
        iifname "incusbr0" udp dport 53 accept;
        iifname "incusbr0" tcp dport 53 accept;

        # SSH
        tcp dport 22 accept;

        # Web
        tcp dport { 80, 443 } accept;

        # WireGuard
        udp dport { 53820, 53821, 53822 } accept;

        # Cockpit
        tcp dport 9090 ip saddr @trusted accept;
        tcp dport 9090 iifname "wg1" accept;

        # HAProxy stats
        tcp dport 8404 ip saddr @trusted accept;

        # Incus UI/API pouze z WireGuard sítě
        iifname "wg1" ip saddr 10.100.100.0/24 tcp dport 8443 accept;

        # Logging
        limit rate 5/minute log prefix "FW DROP IN: ";
        drop;
      }

      chain output {
        type filter hook output priority filter; policy accept;
      }
    }

    table inet nat {

      chain prerouting {
        type nat hook prerouting priority dstnat; policy accept;

        ${allDnatRules}
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