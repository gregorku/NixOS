{
  # ─────────────────────────────────────
  # WIREGUARD DNAT
  # ─────────────────────────────────────
  #
  # Tato část je připravena jako vzor.
  #
  # Firewall modul zatím WireGuard pravidla
  # negeneruje.
  #
  # Až bude WireGuard nakonfigurován,
  # lze generování pravidel aktivovat
  # ve firewall-domaServerPc.nix.

  wireguard = {


    # ───────────────────────────────────
    # WG1
    # ───────────────────────────────────

    wg1 = [

      # { port = 19443; target = "200.1.1.100:9443"; }

      # { port = 19444; target = "200.1.1.110:9443"; }

      # { port = 19447; target = "200.1.1.111:9443"; }

      # { port = 8887; target = "200.1.1.200:8887"; }

      # { port = 8888; target = "200.1.1.200:8888"; }

      # { port = 8889; target = "200.1.1.200:8889"; }

      # { port = 12022; target = "200.1.1.200:22"; }

      # { port = 19200; target = "200.1.1.200:9443"; }

      # { port = 19446; target = "200.1.1.120:9443"; }

      # { port = 3001; target = "200.1.1.110:3001"; }

      # { port = 8080; target = "200.1.1.110:8080"; }

      # { port = 9090; target = "200.1.1.111:9090"; }

      # { port = 9091; target = "200.1.1.171:9090"; }
    ];


    # ───────────────────────────────────
    # WG3
    # ───────────────────────────────────

    wg3 = [

      # { port = 10051; target = "200.1.1.111:10051"; }
    ];
  };


  # ─────────────────────────────────────
  # PUBLIC / LAN DNAT
  # ─────────────────────────────────────
  #
  # Tato pravidla jsou generována na:
  #
  #   iifname "br0"
  #
  # Aktuálně není aktivní žádné DNAT
  # přesměrování.
  #
  # Jednotlivé položky aktivujte až podle
  # skutečných IP adres kontejnerů a služeb.

  public = [

    # Kamera / služba 1
    #
    # { port = 8182; target = "10.110.100.220:8182"; }
    #
    # { port = 5541; target = "10.110.100.220:5541"; }


    # Kamera / služba 2
    #
    # { port = 8181; target = "10.110.100.210:8181"; }
    #
    # { port = 5540; target = "10.110.100.210:5540"; }


    # Další služba
    #
    # { port = 8000; target = "10.110.100.200:8000"; }
  ];
}