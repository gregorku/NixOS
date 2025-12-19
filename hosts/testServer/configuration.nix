{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ##################################################
    # Common – sdílené moduly
    ##################################################
    ../../modules/common-base.nix
    ../../modules/common-security.nix
    ../../modules/common-snapshots.nix
    ../../modules/common-swap.nix

    ##################################################
    # Server-only moduly
    ##################################################
    ../../modules/server/server-apps.nix
    ../../modules/server/libvirt.nix
    ../../modules/server/cockpit.nix   # Tento modul už jen zapne cockpit a otevře firewall
    ../../modules/server/nspawn.nix
    ../../modules/server/zfs.nix

    ##################################################
    # VM-specific
    ##################################################
    ../../modules/common-vm-guest.nix

    ##################################################
    # Network - POUZE NetworkManager s DHCP
    ##################################################
    ../../modules/common-networkmanager.nix

    ##################################################
    # Containers - ZJEDNODUŠENÉ verze
    ##################################################
    ../../containers/server1-dhcp.nix
    ../../containers/server2-dhcp.nix
  ];

  networking.hostName = "testServer";

  ##################################################
  # Users
  ##################################################
  users.users.gregor = {
    isNormalUser = true;
    description = "Server administrator";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    shell = pkgs.bashInteractive;
    linger = true;
    initialPassword = "zmenit";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2E... váš-ssh-klíč"
    ];
  };

  networking.hostId = "deadbeef";

  ##################################################
  # Lokalizace / Jazyk
  ##################################################
  time.timeZone = "Europe/Prague";
  console.keyMap = "cz";
  i18n.defaultLocale = "cs_CZ.UTF-8";

  ##################################################
  # Bootloader – UEFI (VM)
  ##################################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ##################################################
  # Boot generations cleanup
  ##################################################
  boot.loader.systemd-boot.configurationLimit = 20;

  ##################################################
  # Nix garbage collection
  ##################################################
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  ##################################################
  # Container support
  ##################################################
  boot.enableContainers = true;

  ##################################################
  # DHCP - výchozí nastavení
  ##################################################
  networking.useDHCP = true;

  ##################################################
  # Firewall - jen potřebné porty
  ##################################################
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 9090 8443 9443 ];

  ##################################################
  # Cockpit settings - přepsat výchozí
  ##################################################
  services.cockpit.settings.WebService = {
    AllowUnencrypted = true;
    Origins = lib.mkForce "*";
  };

  system.stateVersion = "25.05";
}
