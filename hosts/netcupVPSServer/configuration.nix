{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
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
    #../../modules/security/serverVPS-unlock.nix
    #../../modules/security/serverVPS-unlock-setupPc.nix

    ##################################################
    # VPS-specific
    ##################################################
    ../../modules/server/incus-netcupVPSServer.nix
    ../../modules/server/firewall/firewall-vps-netcup.nix

    ##################################################
    # WireGuard
    ##################################################
    ../../modules/server/wireguard-netcupVPSServer.nix

    ##################################################
    # HAProxy
    ##################################################
    ../../modules/server/haproxy-netcupVPSServer.nix

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

  age.secrets.netcupVPS-secret.file = ../../secrets/serverVPSnetcup/netcupVPS-secret.age;

  # Zpřístupnění secretu do systému.
  nvironment.etc."netcupVPS-secret".source = config.age.secrets.netcupVPS-secret.path;

  ##################################################
  # Host
  ##################################################
  networking.hostName = "netcupVPSServer";
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

  nix.settings = {
    auto-optimise-store = true;

    # Testovací VPS – menší spotřeba RAM při buildu
    max-jobs = 1;
    cores = 1;
  };

  # Přidání klasického swapfile vedle zram
  swapDevices = [
    {
      device = "/swapfile";
      size = 4096; # MiB = 4 GiB
    }
  ];

  ##################################################
  # Version
  ##################################################

  system.stateVersion = "26.05";
}
