{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ##################################################
    # Common – sdílené moduly
    ##################################################
    ../../modules/common-security.nix
    ../../modules/common-snapshots.nix
    ../../modules/common-server-swap.nix

    ##################################################
    # Server-only moduly
    ##################################################
    ../../modules/server/server-apps.nix
    ../../modules/server/libvirt.nix
    ../../modules/server/cockpit.nix
    ../../modules/server/zfs.nix

    ##################################################
    # Network - POUZE NetworkManager s DHCP
    ##################################################
    ../../modules/common-networkmanager.nix


  ];

  networking.hostName = "domaPcServer";

  ##################################################
  # Users
  ##################################################
  users.users.gregor = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    initialPassword = "zmenit";
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

  system.stateVersion = "24.05";
}
