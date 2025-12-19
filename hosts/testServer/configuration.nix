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
    # [cite_start]Přidány skupiny 'podman' a 'docker' pro správu v Cockpitu [cite: 5]
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "podman" "docker" ];
    shell = pkgs.bashInteractive;
    linger = true;
    [cite_start]initialPassword = "zmenit"; [cite: 5]
  };

  ##################################################
  # Cockpit Pluginy (pro zobrazení kontejnerů a VM)
  ##################################################
  environment.systemPackages = with pkgs; [
    cockpit-machines  # Správa nspawn kontejnerů a Libvirt VM
    cockpit-podman    # Správa Podman/Docker kontejnerů
  ];

  ##################################################
  # ZFS host ID (required)
  ##################################################
  [cite_start]networking.hostId = "deadbeef"; [cite: 6]

  ##################################################
  # Lokalizace / Jazyk
  ##################################################
  [cite_start]time.timeZone = "Europe/Prague"; [cite: 7]
  [cite_start]console.keyMap = "cz"; [cite: 7]
  [cite_start]i18n.defaultLocale = "cs_CZ.UTF-8"; [cite: 7]

  ##################################################
  # Bootloader – UEFI (VM)
  ##################################################
  [cite_start]boot.loader.systemd-boot.enable = true; [cite: 8]
  [cite_start]boot.loader.efi.canTouchEfiVariables = true; [cite: 8]

  ##################################################
  # Boot generations cleanup
  ##################################################
  [cite_start]boot.loader.systemd-boot.configurationLimit = 5; [cite: 9]

  ##################################################
  # Nix garbage collection
  ##################################################
  nix.gc = {
    [cite_start]automatic = true; [cite: 10]
    [cite_start]dates = "weekly"; [cite: 11]
    [cite_start]options = "--delete-older-than 7d"; [cite: 11]
  };

  ##################################################
  # POVINNÉ – po instalaci už NEMĚNIT
  ##################################################
  [cite_start]system.stateVersion = "25.05"; [cite: 12]
}
