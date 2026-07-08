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

    # Automatické vzdálené odemykání LUKS serverů
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

    # ../../modules/server/profiles/test.nix
  ];


  ##################################################
  # AGENIX SECRET
  ##################################################

  age.secrets.test-secret.file =
    ../../serverVPStest/test-secret.age;

  # Zpřístupnění secretu do systému
  environment.etc."test-secret".source =
    config.age.secrets.test-secret.path;


  ##################################################
  # Server Unlock
  ##################################################
  #
  # Automatické odemykání LUKS serverů přes SSH
  # dostupné v initrd.
  #
  # Všechny servery jsou dostupné přes VPN adresu
  # MikroTik routeru:
  #
  #   10.100.100.5
  #
  # unlockPort:
  #   SSH port initrd pro odemčení LUKS.
  #
  # normalPort:
  #   SSH port běžícího systému.
  #   Používá se pro zjištění, zda je server již
  #   normálně spuštěný.
  #
  # passwordFile:
  #   Soubor obsahující LUKS passphrase.
  #
  #   Tyto soubory NESMÍ být v Git repozitáři.
  #

  services.serverUnlock = {
    enable = true;

    checkInterval = 10;

    unlockTimeout = 900;

    bootTimeout = 600;

    logLevel = "info";


    servers = {

      ################################################
      # testServerPrace
      ################################################

      testServerPrace = {
        host = "10.100.100.5";

        unlockPort = 2223;

        # Uprav podle skutečného portu.
        normalPort = 10522;

        passwordFile =
          "/etc/secrets/server-unlock/testServerPrace.pass";
      };


      ################################################
      # virtServerPrace
      ################################################

      virtServerPrace = {
        host = "10.100.100.5";

        unlockPort = 2224;

        # UPRAV podle skutečného SSH portu.
        normalPort = 10523;

        passwordFile =
          "/etc/secrets/server-unlock/virtServerPrace.pass";
      };


      ################################################
      # pcServerPrace
      ################################################

      pcServerPrace = {
        host = "10.100.100.5";

        unlockPort = 2225;

        # UPRAV podle skutečného SSH portu.
        normalPort = 10524;

        passwordFile =
          "/etc/secrets/server-unlock/pcServerPrace.pass";
      };


      ################################################
      # pracovniPc
      ################################################

      pracovniPc = {
        host = "10.100.100.5";

        unlockPort = 2226;

        # UPRAV podle skutečného SSH portu.
        normalPort = 10525;

        passwordFile =
          "/etc/secrets/server-unlock/pracovniPc.pass";
      };


      ################################################
      # domaPcServer
      ################################################

      domaPcServer = {
        host = "10.100.100.5";

        unlockPort = 2227;

        # UPRAV podle skutečného SSH portu.
        normalPort = 10526;

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