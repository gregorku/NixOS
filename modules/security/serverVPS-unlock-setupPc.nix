{
  config,
  lib,
  pkgs,
  ...
}:

{
  ##################################################
  # Server Unlock
  ##################################################
  #
  # Automatické vzdálené odemykání LUKS serverů.
  #
  # Princip:
  #
  # 1. VPS kontroluje produkční SSH port serveru.
  #
  # 2. Pokud produkční SSH neodpovídá,
  #    zkontroluje SSH port initrd.
  #
  # 3. Pokud initrd SSH odpovídá,
  #    připojí se pomocí SSH klíče:
  #
  #      /root/.ssh/unlock_servers
  #
  # 4. Spustí:
  #
  #      systemd-tty-ask-password-agent
  #
  # 5. Předá LUKS passphrase ze souboru
  #    uloženého lokálně na VPS.
  #
  # 6. Po odemčení čeká na produkční SSH port.
  #
  # Všechny cílové porty jsou dostupné přes VPN
  # adresu příslušného MikroTik routeru.
  #
  # Pro první test byl aktivní:
  #
  #      testServerPrace
  #
  # Ostatní servery lze aktivovat postupně
  # po úspěšném ověření automatického odemykání.
  #
  #
  # DŮLEŽITÉ:
  #
  # unlockTimeout zde neslouží jako timeout,
  # po kterém by VPS přestal čekat na server.
  #
  # Server může zůstat v initrd a čekat na
  # odemčení libovolně dlouho.
  #
  # Opakovaná kontrola dostupnosti serveru je
  # řízena pomocí checkInterval.
  #
  # Po odeslání passphrase se používá bootTimeout
  # pouze pro čekání na návrat produkčního SSH.
  #
  ##################################################

  services.serverUnlock = {
    enable = true;

    # ──────────────────────────────────────────────
    # Interval kontroly serverů
    # ──────────────────────────────────────────────
    #
    # Každých 10 sekund se kontroluje stav:
    #
    #   1. produkčního SSH
    #   2. případně initrd SSH
    #
    checkInterval = 10;

    # ──────────────────────────────────────────────
    # Unlock timeout
    # ──────────────────────────────────────────────
    #
    # Hodnota je připravena pro případné budoucí
    # rozšíření logiky služby.
    #
    # V současné implementaci NEUKONČUJE čekání
    # na server.
    #
    # To je záměrné.
    #
    # Pokud je server v initrd a čeká na LUKS,
    # VPS musí být schopný čekat neomezeně dlouho
    # a po obnovení dostupnosti initrd SSH
    # odemčení provést.
    #
    unlockTimeout = 900;

    # ──────────────────────────────────────────────
    # Boot timeout
    # ──────────────────────────────────────────────
    #
    # Maximální doba čekání na produkční SSH
    # po odeslání LUKS passphrase.
    #
    # 600 sekund = 10 minut.
    #
    # Tato hodnota se týká již probíhajícího bootu,
    # nikoliv čekání na dostupnost initrd.
    #
    bootTimeout = 600;

    # ──────────────────────────────────────────────
    # Logování
    # ──────────────────────────────────────────────
    #
    # Pro testování:
    #
    #   debug
    #
    # Po dokončení testování lze změnit na:
    #
    #   info
    #
    logLevel = "debug";

    ################################################
    # Cílové PC servery
    ################################################

    servers = {

      ################################################
      # testServerPrace
      ################################################
      #
      # První testovací server.
      #
      # VPN cíl:
      #
      #   10.100.100.5
      #
      # initrd SSH:
      #
      #   port 2223
      #
      # produkční SSH:
      #
      #   port 10522
      #
      # LUKS passphrase:
      #
      #   /etc/secrets/server-unlock/
      #   testServerPrace.pass
      #

      testServerPrace = {
        host = "10.100.100.5";

        unlockPort = 2223;

        normalPort = 10522;

        # SSH host key initrd serveru.
        #
        # VPS pomocí něj ověřuje identitu
        # cílového SSH serveru.
        #
        hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQjYeNfmlGn8fXI9V2jpzX0ZCM/KqHrtgoDOgRdhHyg";

        # Privátní SSH klíč na VPS.
        #
        # VPS se tímto klíčem autentizuje
        # vůči SSH serveru v initrd.
        #
        keyFile = "/root/.ssh/unlock_servers";

        # LUKS passphrase uložená lokálně na VPS.
        #
        # Soubor není součástí Git repozitáře.
        #
        passwordFile = "/etc/secrets/server-unlock/testServerPrace.pass";
      };

      ################################################
      # virtServerPrace
      ################################################
      #
      # Aktivovat až po ověření testServerPrace.
      #
      # VPN cíl:
      #
      #   10.100.100.5
      #
      # initrd SSH:
      #
      #   2224
      #
      # produkční SSH:
      #
      #   10523
      #

      # virtServerPrace = {
      #   host = "10.100.100.5";
      #
      #   unlockPort = 2224;
      #
      #   normalPort = 10523;
      #
      #   hostPublicKey =
      #     "ssh-ed25519 AAAA... virtServerPrace";
      #
      #   keyFile =
      #     "/root/.ssh/unlock_servers";
      #
      #   passwordFile =
      #     "/etc/secrets/server-unlock/virtServerPrace.pass";
      # };

      ################################################
      # pcServerPrace
      ################################################
      #
      # Aktivovat až po ověření testServerPrace.
      #
      # VPN cíl:
      #
      #   10.100.100.5
      #
      # initrd SSH:
      #
      #   2225
      #
      # produkční SSH:
      #
      #   10524
      #

      # pcServerPrace = {
      #   host = "10.100.100.5";
      #
      #   unlockPort = 2225;
      #
      #   normalPort = 10524;
      #
      #   hostPublicKey =
      #     "ssh-ed25519 AAAA... pcServerPrace";
      #
      #   keyFile =
      #     "/root/.ssh/unlock_servers";
      #
      #   passwordFile =
      #     "/etc/secrets/server-unlock/pcServerPrace.pass";
      # };

      ################################################
      # pracovniPc
      ################################################
      #
      # Aktivovat až po ověření testServerPrace.
      #
      # VPN cíl:
      #
      #   10.100.100.5
      #
      # initrd SSH:
      #
      #   2226
      #
      # produkční SSH:
      #
      #   10525
      #

      # pracovniPc = {
      #   host = "10.100.100.5";
      #
      #   unlockPort = 2226;
      #
      #   normalPort = 10525;
      #
      #   hostPublicKey =
      #     "ssh-ed25519 AAAA... pracovniPc";
      #
      #   keyFile =
      #     "/root/.ssh/unlock_servers";
      #
      #   passwordFile =
      #     "/etc/secrets/server-unlock/pracovniPc.pass";
      # };

      ################################################
      # domaPcServer
      ################################################
      #
      # Aktivovat po samostatném otestování serveru.
      #
      # VPN cíl:
      #
      #   10.100.100.100
      #
      # initrd SSH:
      #
      #   2227
      #
      # produkční SSH:
      #
      #   10022
      #
      # LUKS passphrase:
      #
      #   /etc/secrets/server-unlock/
      #   domaPcServer.pass
      #

      domaPcServer = {
        host = "10.100.100.100";

        unlockPort = 2227;

        normalPort = 10022;

        # SSH host key initrd serveru.
        #
        # VPS pomocí něj ověřuje identitu
        # cílového SSH serveru.
        #
        hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWjGsXeAtGIEBoclDPnKF+gTvMsNZGrsqh42DvGsPEj";

        # Privátní SSH klíč na VPS.
        #
        keyFile = "/root/.ssh/unlock_servers";

        # LUKS passphrase uložená lokálně na VPS.
        #
        passwordFile = "/etc/secrets/server-unlock/domaPcServer.pass";
      };
    };
  };
}
