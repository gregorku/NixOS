{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ##################################################
    # Common – sdílené moduly
    ##################################################
    ../../modules/common-base.nix
    ../../modules/common-security.nix
    ../../modules/common-swap.nix
    ../../modules/server/server-users.nix


    ##################################################
    # Server-only moduly
    ##################################################
    ../../modules/server/serverVPS-app.nix
    ../../modules/server/cockpit.nix


    ##################################################
    # Security
    ##################################################

    # Automatické vzdálené odemykání LUKS serverů.
    ../../modules/security/server-unlock.nix

    ##################################################
    # VPS-specific
    ##################################################
    ../../modules/server/incus-vps-test.nix
    # ../../modules/server/haproxy-test.nix
    ../../modules/server/firewall/firewall-vps-test.nix


    ##################################################
    # WireGuard
    ##################################################
    ../../modules/server/wireguard-vps-test.nix


    ##################################################
    # HAProxy
    ##################################################
    ../../modules/server/haproxy-test.nix

    # ../../modules/server/security.nix
    # ../../modules/server/security-test.nix
    # ../../modules/server/acme.nix
  
    # Monitoring server Pc.
    #
    ../../modules/server/monitoringVPS.nix
  ];


  ##################################################
  # AGENIX SECRET
  ##################################################

  age.secrets.test-secret.file =
    ../../serverVPStest/test-secret.age;

  # Zpřístupnění secretu do systému.
  environment.etc."test-secret".source =
    config.age.secrets.test-secret.path;


  ##################################################
  # Server Unlock
  ##################################################
  #
  # Automatické vzdálené odemykání LUKS serverů.
  #
  # Princip:
  #
  #   1. VPS kontroluje produkční SSH port serveru.
  #
  #   2. Pokud produkční SSH neodpovídá,
  #      zkontroluje SSH port initrd.
  #
  #   3. Pokud initrd SSH odpovídá,
  #      připojí se pomocí SSH klíče:
  #
  #        /root/.ssh/unlock_servers
  #
  #   4. Spustí:
  #
  #        systemd-tty-ask-password-agent
  #
  #   5. Předá LUKS passphrase ze souboru
  #      uloženého lokálně na VPS.
  #
  #   6. Po odemčení čeká na produkční SSH port.
  #
  # Všechny cílové porty jsou dostupné přes VPN
  # adresu MikroTik routeru:
  #
  #   10.100.100.5
  #
  # Pro první test je aktivní pouze:
  #
  #   testServerPrace
  #
  # Ostatní servery budou aktivovány postupně
  # po úspěšném ověření automatického odemykání.
  #

  services.serverUnlock = {
    enable = true;


    # Interval mezi kontrolami serverů.
    #
    # Každých 10 sekund se kontroluje stav
    # produkčního a případně initrd SSH portu.
    #
    checkInterval = 10;


    # Maximální doba čekání související
    # s dostupností initrd SSH.
    #
    # Hodnota je připravena pro další rozšíření
    # logiky služby.
    #
    unlockTimeout = 900;


    # Maximální doba čekání na produkční SSH
    # po odeslání LUKS passphrase.
    #
    # 600 sekund = 10 minut.
    #
    bootTimeout = 600;


    # Úroveň logování.
    #
    # Pro první test doporučuji "debug".
    # Po dokončení testování lze změnit na "info".
    #
    logLevel = "debug";


    servers = {

      ################################################
      # testServerPrace
      ################################################
      #
      # První testovací server.
      #
      # initrd SSH:
      #   port 2223
      #
      # produkční SSH:
      #   port 10522
      #
      # VPN cíl:
      #   10.100.100.5
      #

      testServerPrace = {
        host = "10.100.100.5";

        unlockPort = 2223;

        normalPort = 10522;

        hostPublicKey =
         "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQjYeNfmlGn8fXI9V2jpzX0ZCM/KqHrtgoDOgRdhHyg";

        keyFile =
          "/root/.ssh/unlock_servers";

        passwordFile =
          "/etc/secrets/server-unlock/testServerPrace.pass";
      };


      ################################################
      # virtServerPrace
      ################################################
      #
      # Aktivovat až po ověření testServerPrace.
      #
      # virtServerPrace = {
      #   host = "10.100.100.5";
      #
      #   unlockPort = 2224;
      #
      #   normalPort = 10523;
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
      # pcServerPrace = {
      #   host = "10.100.100.5";
      #
      #   unlockPort = 2225;
      #
      #   normalPort = 10524;
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
      # pracovniPc = {
      #   host = "10.100.100.5";
      #
      #   unlockPort = 2226;
      #
      #   normalPort = 10525;
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
      # Aktivovat až po ověření testServerPrace.
      #
      domaPcServer = {
        host = "10.100.100.100";

        unlockPort = 2227;

        normalPort = 10022;

        hostPublicKey =
         "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWjGsXeAtGIEBoclDPnKF+gTvMsNZGrsqh42DvGsPEj";

        keyFile =
         "/root/.ssh/unlock_servers";

        passwordFile =
         "/etc/secrets/server-unlock/domaPcServer.pass";
      };
    };
  };


  ##################################################
  # Host
  ##################################################

  networking.hostName = "VPSServer";
  networking.hostId = "ab12cd34";


  ##################################################
  # Síť
  ##################################################

  networking.useDHCP = false;

  systemd.network.enable = true;

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "ens3";

    networkConfig = {
      DHCP = "yes";
      IPv6AcceptRA = true;
    };

    dhcpV4Config.RouteMetric = 100;
  };


  ##################################################
  # Kernel
  ##################################################

  boot.kernelModules = [
    "br_netfilter"
    "overlay"
    "nf_conntrack"
  ];


  ##################################################
  # Lokalizace
  ##################################################

  time.timeZone = "Europe/Prague";

  console.keyMap = "cz";

  i18n.defaultLocale = "cs_CZ.UTF-8";


  ##################################################
  # Bootloader (UEFI)
  ##################################################

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.configurationLimit = 10;


  ##################################################
  # SSH (dočasně otevřené)
  ##################################################

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
      X11Forwarding = false;
    };
  };


  ##################################################
  # Nix
  ##################################################

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;


  ##################################################
  # Version
  ##################################################

  system.stateVersion = "26.05";
}