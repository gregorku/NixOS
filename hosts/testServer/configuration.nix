{ config, pkgs, ... }:

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
    ../../modules/server/bridge-network.nix
    ../../modules/server/libvirt.nix
    ../../modules/server/cockpit.nix
    ../../modules/server/nspawn.nix
    ../../modules/server/zfs.nix

    ##################################################
    # VM-specific
    ##################################################
    ../../modules/common-vm-guest.nix

    ##################################################
    # Containers
    ##################################################
    ./containers/test1.nix
  ];

  ##################################################
  # Hostname
  ##################################################
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
  };

  ##################################################
  # ZFS host ID (required)
  ##################################################
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
  boot.loader.systemd-boot.configurationLimit = 5;

  ##################################################
  # Nix garbage collection (server-friendly)
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
  # POVINNÉ – po instalaci už NEMĚNIT
  ##################################################
  system.stateVersion = "25.05";
}
