{...}: {
  ##################################################
  # Automatic Server LUKS Unlock Manager
  ##################################################

  services.serverUnlock = {
    enable = true;

    # Pravidelná kontrola serverů
    # 300 sekund = 5 minut
    checkInterval = 300;

    # Maximální čekání na produkční SSH po odemčení
    bootTimeout = 600;

    # Rezervovaná hodnota modulu
    unlockTimeout = 900;

    # Úroveň logování
    logLevel = "debug";

    ################################################
    # Spravované servery
    ################################################

    servers = {
      ################################################
      # pracepcserver
      ################################################
      #
      # VPN adresa MikroTiku:
      #   10.100.100.12
      #
      # Initrd SSH:
      #   MikroTik 2223 -> server 2223
      #
      # Produkční SSH:
      #   MikroTik 10022 -> server 22
      #
      # Initrd host key fingerprint:
      #   SHA256:3lfGn597R7eldSDvkssbrsOzJGDwlm2RBNw47sOYqhk
      #

      pracepcserver = {
        host = "10.100.100.12";

        unlockPort = 2223;

        normalPort = 10022;

        hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7uhCJ58PkTbzo8CN+LTj89F7PfyQIjR+kuiUY5BBTu";

        keyFile = "/root/.ssh/unlock_servers";

        passwordFile = "/etc/secrets/server-unlock/pracepcserver.pass";
      };

      ################################################
      # domaPcServer
      ################################################
      #
      # VPN adresa MikroTiku:
      #   10.100.100.100
      #
      # Initrd SSH:
      #   2227
      #
      # Produkční SSH:
      #   10022
      #

      domaPcServer = {
        host = "10.100.100.100";

        unlockPort = 2227;

        normalPort = 10022;

        hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWjGsXeAtGIEBoclDPnKF+gTvMsNZGrsqh42DvGsPEj";

        keyFile = "/root/.ssh/unlock_servers";

        passwordFile = "/etc/secrets/server-unlock/domaPcServer.pass";
      };

      ################################################
      # testServerPrace
      ################################################
      #
      # VPN adresa MikroTiku:
      #   10.100.100.5
      #
      # Initrd SSH:
      #   2223
      #
      # Produkční SSH:
      #   10522
      #

      testServerPrace = {
        host = "10.100.100.5";

        unlockPort = 2223;

        normalPort = 10522;

        hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQjYeNfmlGn8fXI9V2jpzX0ZCM/KqHrtgoDOgRdhHyg";

        keyFile = "/root/.ssh/unlock_servers";

        passwordFile = "/etc/secrets/server-unlock/testServerPrace.pass";
      };
    };
  };
}
