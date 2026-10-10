{
  config,
  pkgs,
  lib,
  ...
}: {
  # ─────────────────────────────────────
  # NFTABLES
  # ─────────────────────────────────────
  #
  # Notebook používá vlastní nftables
  # firewall stejně jako server.
  #
  # Standardní NixOS firewall je vypnutý
  # a veškeré filtrování provádí tento
  # ruleset.
  #
  # Modul je určen pro:
  #
  #   - LAN
  #   - MikroTik / WinBox
  #   - WireGuard
  #   - Incus
  #
  # DNAT zde zatím není.
  #

  networking.nftables.enable = true;

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
      # LAN:
      #
      #   192.168.100.0/24
      #
      # WireGuard:
      #
      #   10.10.10.0/24
      #   10.100.100.0/24
      #   10.110.100.0/24
      #   10.120.100.0/24
      #
      # Incus:
      #
      #   10.10.10.0/24
      #
      # Sítě zde uvedené lze použít
      # pro administrační služby.
      #

      set trusted {
        type ipv4_addr;
        flags interval;

        elements = {
          127.0.0.1/32,
          192.168.100.0/24,
          10.10.10.0/24,
          10.100.100.0/24,
          10.110.100.0/24,
          10.120.100.0/24
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
        # SSH je zatím povolen ze všech sítí.
        #
        # Později lze případně omezit:
        #
        #   tcp dport 22 ip saddr @trusted accept
        #

        tcp dport 22 accept;


        # ───────────────────────────────
        # WINBOX
        # ───────────────────────────────
        #
        # WinBox používá:
        #
        #   TCP 8291
        #
        # pro standardní WinBox připojení.
        #

        tcp dport 8291 ip saddr @trusted accept;


        # ───────────────────────────────
        # MIKROTIK DISCOVERY
        # ───────────────────────────────
        #
        # MikroTik Neighbor Discovery:
        #
        #   UDP 5678
        #
        # WinBox pod Linuxem tento port
        # používá pro vyhledávání MikroTiků.
        #
        # Discovery povolujeme pouze z LAN
        # přes fyzické ethernetové rozhraní.
        #

        iifname "eno1" udp dport 5678 accept;
        iifname "wlp4s0" udp dport 5678 accept;


        # ───────────────────────────────
        # MIKROTIK MAC WINBOX
        # ───────────────────────────────
        #
        # MikroTik MAC server / MAC WinBox:
        #
        #   UDP 20561
        #
        # Povolen pouze z trusted sítí.
        #

        udp dport 20561 ip saddr @trusted accept;


        # ───────────────────────────────
        # HTTP / HTTPS
        # ───────────────────────────────
        #
        # Ponecháno pro budoucí webové
        # služby na notebooku.
        #

        tcp dport {
          80,
          443
        } accept;

        # ───────────────────────────────
        # AVAHI / mDNS – síťové tiskárny
        # ───────────────────────────────

        # IPv4 mDNS – lokální síť
        iifname "wlp4s0" \
          ip saddr 192.168.100.0/24 \
          ip daddr 224.0.0.251 \
          udp dport 5353 accept;

        # IPv6 mDNS – link-local provoz
        iifname "wlp4s0" \
          ip6 saddr fe80::/10 \
          ip6 daddr ff02::fb \
          udp dport 5353 accept;

        # ───────────────────────────────
        # WIREGUARD
        # ───────────────────────────────
        #
        # WireGuard listen port.
        #
        # Pokud používáš jiný port, upraví se
        # zde.
        #

        udp dport 51820 accept;


        # ───────────────────────────────
        # INCUS API
        # ───────────────────────────────
        #
        # Incus API přes:
        #
        #   8443
        #
        # pouze z LAN / trusted sítí.
        #

        tcp dport 8443 ip saddr @trusted accept;


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
      #
      # Forwarding je potřeba pro:
      #
      #   - Incus kontejnery
      #   - br0
      #   - WireGuard
      #

      chain forward {
        type filter hook forward priority filter;
        policy drop;


        # ───────────────────────────────
        # EXISTUJÍCÍ SPOJENÍ
        # ───────────────────────────────

        ct state established,related accept;


        # ───────────────────────────────
        # INCUS KONTEJNERY PŘES br0
        # ───────────────────────────────
        #
        # Kontejnery připojené přímo
        # do fyzické LAN přes br0.
        #
        # Povolení obou směrů umožňuje
        # kontejnerům komunikovat s LAN.
        #

        iifname "br0" accept;
        oifname "br0" accept;


        # ───────────────────────────────
        # INCUS NAT NETWORK
        # ───────────────────────────────
        #
        # Incus síť:
        #
        #   incusbr0
        #
        # NAT vytváří Incus.
        #

        iifname "incusbr0" accept;
        oifname "incusbr0" accept;


        # ───────────────────────────────
        # WIREGUARD
        # ───────────────────────────────
        #
        # Povolení provozu mezi WireGuard
        # rozhraním a ostatními sítěmi.
        #
        # Používá wildcard pro wg rozhraní:
        #
        #   wg0
        #   wg1
        #   wg2
        #   ...
        #

        iifname "wg*" accept;
        oifname "wg*" accept;


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
      #
      # Odchozí komunikace je povolena.
      #

      chain output {
        type filter hook output priority filter;
        policy accept;
      }
    }
  '';

  # ─────────────────────────────────────
  # BALÍČKY
  # ─────────────────────────────────────

  environment.systemPackages = with pkgs; [
    nftables
  ];
}
