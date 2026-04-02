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

    ##################################################
    # Server-only moduly
    ##################################################
    ../../modules/server/serverVPS-app.nix
    ../../modules/server/cockpit.nix

    ##################################################
    # VPS-specific
    ##################################################
    ../../modules/server/incus.nix
    # ../../modules/server/haproxy.nix
    ../../modules/server/firewall-vps.nix

    ##################################################
    # WireGuard
    ##################################################
    ../../modules/common-wireguard.nix
  ];

  ##################################################
  # agenix + age
  ##################################################
  environment.systemPackages = [
    pkgs.age
    inputs.agenix.packages.${pkgs.system}.default
  ];

  # kde má agenix hledat private key
  age.identityPaths = [ "/root/.config/age/keys.txt" ];

  ##################################################
  # AGENTIX SECRET (NOVÉ 🔥)
  ##################################################
  age.secrets.test-secret.file = ../../serverVPStest/test-secret.age;

  # zpřístupnění do systému
  environment.etc."test-secret".source =
    config.age.secrets.test-secret.path;

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
  # Uživatelé
  ##################################################
  users.users.gregor = {
    isNormalUser = true;
    description  = "Server administrator";
    extraGroups  = [ "wheel" "incus-admin" ];
    shell        = pkgs.bashInteractive;
    linger       = true;
    initialPassword = "zmenit"; # změň ASAP

    openssh.authorizedKeys.keys = [
      # TODO: přesunout do agenix později
      "ssh-rsa AAAAB3NzaC1yc2E..."
    ];
  };

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
  system.stateVersion = "25.11";
  
}