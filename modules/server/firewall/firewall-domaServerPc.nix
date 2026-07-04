{ config, pkgs, lib, ... }:

let
  # ─────────────────────────────────────
  # DNAT konfigurace
  # ─────────────────────────────────────

  dnat = import ./dnat-domaServerPc.nix;


  # ─────────────────────────────────────
  # Generátor jednoho DNAT pravidla
  # ─────────────────────────────────────
  #
  # Příklad výsledku:
  #
  # iifname "br0" tcp dport 8182
  #   dnat ip to 10.110.100.220:8182

  genRule = iface: r:
    ''
      iifname "${iface}" tcp dport ${toString r.port} dnat ip to ${r.target}
    '';


  # ─────────────────────────────────────
  # Veřejné / LAN DNAT porty přes br0
  # ─────────────────────────────────────
  #
  # domaPcServer používá:
  #
  #   br0
  #
  # místo původního:
  #
  #   ens3

  publicRules =
    map
      (r: genRule "br0" r)
      dnat.public;


  # ─────────────────────────────────────
  # WireGuard DNAT
  # ─────────────────────────────────────
  #
  # Zatím není aktivní.
  #
  # Až bude WireGuard nakonfigurován, lze
  # doplnit generování například:
  #
  # wg1Rules =
  #   map
  #     (r: genRule "wg1" r)
  #     dnat.wireguard.wg1;
  #
  # wg3Rules =
  #   map
  #     (r: genRule "wg3" r)
  #     dnat.wireguard.wg3;


  # ─────────────────────────────────────
  # Spojení aktivních DNAT pravidel
  # ─────────────────────────────────────

  allDnatRules =
    lib.concatStringsSep "\n"
      publicRules;

in
{
  # ─────────────────────────────────────
  # NFTABLES
  # ─────────────────────────────────────

  networking.nftables.enable = true;


  # Standardní NixOS firewall je vypnutý.
  #
  # Veškeré filtrování provádí tento
  # nftables ruleset.

  networking.firewall.enable = false;


  # ─────────────────────────────────────
  # NFTABLES RULESET
  # ─────────────────────────────────────

  networking.nftables.ruleset = ''

    table inet filter {


      # ─────────────────────────────────
      # TRUSTED NETWORKS
      # ─────────────────────────────────
      #
      # Používá se například pro:
      #
      #   Cockpit
      #   HAProxy stats
      #   další administrační služby

      set trusted {
        type ipv4_addr;
        flags interval;

        elements = {
          127.0.0.1/32,
          192.168.100.0/24
        };
      }


      # ─────────────────────────────────
      # INPUT
      # ─────────────────────────────────

      chain input {
        type filter hook input priority filter;
        policy drop;


        # ───────────────────────────────
        # EXISTUJÍCÍ SPOJENÍ
        # ───────────────────────────────

        ct state established,related accept;


        # ───────────────────────────────
        # LOCALHOST
        # ───────────────────────────────

        iifname "lo" accept;


        # ───────────────────────────────
        # ICMP / PING
        # ───────────────────────────────

        ip protocol icmp accept;

        ip6 nexthdr icmpv6 accept;


        # ───────────────────────────────
        # SSH
        # ───────────────────────────────
        #
        # Zatím povoleno ze všech sítí.
        #
        # Později lze omezit například:
        #
        # tcp dport 22 ip saddr @trusted accept

        tcp dport 22 accept;


        # ───────────────────────────────
        # HTTP / HTTPS
        # ───────────────────────────────
        #
        # Ponecháno pro budoucí:
        #
        # reverse proxy
        # webové služby
        # ACME challenge

        tcp dport {
          80,
          443
        } accept;


        # ───────────────────────────────
        # COCKPIT
        # ───────────────────────────────
        #
        # Přístup pouze z:
        #
        #   localhost
        #   192.168.100.0/24

        tcp dport 9090 ip saddr @trusted accept;


        # ───────────────────────────────
        # HAPROXY STATS
        # ───────────────────────────────
        #
        # Zatím vypnuto.
        #
        # tcp dport 8404 ip saddr @trusted accept;


        # ───────────────────────────────
        # INCUS API
        # ───────────────────────────────
        #
        # Přístup pouze přes LAN bridge.

        iifname "br0" tcp dport 8443 accept;


        # ───────────────────────────────
        # DALŠÍ PORTY – VZOR
        # ───────────────────────────────
        #
        # tcp dport 8080 accept;
        #
        # tcp dport 3000 ip saddr @trusted accept;
        #
        # udp dport 51820 accept;


        # ───────────────────────────────
        # LOGOVÁNÍ DROPŮ
        # ───────────────────────────────

        limit rate 5/minute \
          log prefix "FW DROP IN: ";

        drop;
      }


      # ─────────────────────────────────
      # FORWARD
      # ─────────────────────────────────

      chain forward {
        type filter hook forward priority filter;
        policy drop;


        # ───────────────────────────────
        # EXISTUJÍCÍ SPOJENÍ
        # ───────────────────────────────

        ct state established,related accept;


        # ───────────────────────────────
        # INCUS NAT NETWORK
        # ───────────────────────────────
        #
        # Incus síť:
        #
        #   incusbr0
        #
        # očekávaný subnet:
        #
        #   10.10.10.0/24
        #
        # NAT bude vytvářet Incus.

        iifname "incusbr0" accept;

        oifname "incusbr0" accept;


        # ───────────────────────────────
        # DNAT SPOJENÍ
        # ───────────────────────────────
        #
        # Povolit provoz, který byl
        # přesměrován v NAT prerouting.

        ct status dnat accept;


        # ───────────────────────────────
        # LOGOVÁNÍ DROPŮ
        # ───────────────────────────────

        limit rate 5/minute \
          log prefix "FW DROP FWD: ";

        drop;
      }


      # ─────────────────────────────────
      # OUTPUT
      # ─────────────────────────────────

      chain output {
        type filter hook output priority filter;
        policy accept;
      }
    }


    # ───────────────────────────────────
    # NAT / DNAT
    # ───────────────────────────────────

    table inet nat {


      # ─────────────────────────────────
      # PREROUTING
      # ─────────────────────────────────

      chain prerouting {
        type nat hook prerouting priority dstnat;
        policy accept;


        # Pravidla jsou generována ze souboru:
        #
        #   dnat-domaServerPc.nix
        #
        # Pokud je:
        #
        #   public = [ ];
        #
        # nevygeneruje se žádné DNAT pravidlo.

        ${allDnatRules}
      }


      # ─────────────────────────────────
      # POSTROUTING
      # ─────────────────────────────────
      #
      # POSTROUTING je záměrně vynechán.
      #
      # NAT pro Incus síť:
      #
      #   10.10.10.0/24
      #
      # vytváří Incus automaticky díky:
      #
      #   ipv4.address = 10.10.10.1/24
      #   ipv4.nat     = true
      #
      # v konfiguraci sítě incusbr0.
    }
  '';


  # ─────────────────────────────────────
  # BALÍČKY
  # ─────────────────────────────────────

  environment.systemPackages = with pkgs; [
    nftables
  ];
}