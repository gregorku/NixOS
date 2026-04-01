{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ##################################################
    # Common – sdílené moduly
    ##################################################
    ../../modules/common-base.nix
    ../../modules/common-security.nix
    # common-snapshots.nix  – ODSTRANĚNO (závisí na ZFS/btrfs, na VPS nevhodné)
    ../../modules/common-swap.nix
    # common-networkmanager.nix – ODSTRANĚNO (desktop NM na server nepatří)
    # common-vm-guest.nix       – ODSTRANĚNO (bare-metal VPS, ne VM guest)

    ##################################################
    # Server-only moduly
    ##################################################
    ../../modules/server/serverVPS-app.nix
    ../../modules/server/cockpit.nix
    # libvirt.nix – ODSTRANĚNO (nahrazeno Incus)
    # nspawn.nix  – ODSTRANĚNO (nahrazeno Incus)
    # zfs.nix     – ODSTRANĚNO (ZFS na VPS = RAM overhead + problematické kernely)

    ##################################################
    # VPS-specific – nové moduly (vytvořit)
    ##################################################
    ../../modules/server/incus.nix
    ../../modules/server/haproxy.nix
    ../../modules/server/firewall-vps.nix

    ##################################################
    # WireGuard – existující modul
    ##################################################
    ../../modules/common-wireguard.nix
  ];

  networking.hostName = "VPSServer";
  # Vygenerujte: head -c4 /dev/urandom | od -A none -t x4 | tr -d ' '
  networking.hostId = "ab12cd34";

  ##################################################
  # Síť – systemd-networkd (NM je pro desktop)
  ##################################################
  networking.useDHCP = false;
  systemd.network.enable = true;

  # Název rozhraní zjistíte po instalaci: `ip link`
  # Netcup typicky: eth0 nebo enp1s0
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "ens3";
    networkConfig = {
      DHCP = "yes";
      IPv6AcceptRA = true;
    };
    dhcpV4Config.RouteMetric = 100;
  };

  ##################################################
  # Kernel – moduly pro Incus + routing
  ##################################################
  boot.kernelModules = [
    "br_netfilter"  # nutné pro Incus bridge
    "overlay"       # overlay FS pro kontejnery
    "nf_conntrack"  # connection tracking
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward"                 = 1;
    "net.ipv6.conf.all.forwarding"        = 1;
    "net.bridge.bridge-nf-call-iptables"  = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
  };

  ##################################################
  # Uživatelé
  ##################################################
  users.users.gregor = {
    isNormalUser = true;
    description  = "Server administrator";
    # libvirtd ODSTRANĚNO, přidáno incus-admin
    extraGroups  = [ "wheel" "incus-admin" ];
    shell        = pkgs.bashInteractive;
    linger       = true;
    initialPassword = "zmenit"; # změňte ihned!
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2E... váš-ssh-klíč"
    ];
  };

  ##################################################
  # Lokalizace
  ##################################################
  time.timeZone    = "Europe/Prague";
  console.keyMap   = "cz";
  i18n.defaultLocale = "cs_CZ.UTF-8";

  ##################################################
  # Bootloader – ověřte typ na Netcup (UEFI nebo BIOS)
  # Pro UEFI (výchozí na novějších VPS):
  ##################################################
  boot.loader.systemd-boot.enable        = true;
  boot.loader.efi.canTouchEfiVariables   = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  ##################################################
  # SSH hardening
  ##################################################
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin         = "yes";
      PasswordAuthentication  = true; # po nastavení SSH klíčů!
      X11Forwarding           = false;
    };
  };

  ##################################################
  # Nix
  ##################################################
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  # boot.enableContainers ODSTRANĚNO – to je pro nspawn, ne Incus

  ##################################################
  # Cockpit – produkční nastavení
  ##################################################
  services.cockpit.settings.WebService = {
    AllowUnencrypted = false;          # HTTPS vždy na produkci
    Origins = lib.mkForce "https://cockpit.vasdomena.cz https://VPS_IP:9090";
  };

  system.stateVersion = "25.11";
}