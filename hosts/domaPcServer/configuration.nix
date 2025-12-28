{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    /etc/nixos/secrets/ssh

    ##################################################
    # Common – sdílené moduly
    ##################################################
    ../../modules/common-security.nix
    ../../modules/common-server-swap.nix
    ../../modules/common-snapshots.nix

    ##################################################
    # Server-only moduly
    ##################################################
    ../../modules/server/server-apps.nix
    ../../modules/server/libvirt.nix
    ../../modules/server/cockpit.nix
    ../../modules/server/zfs.nix
    ../../auto-upgrade.nix

    ##################################################
    # Server-networking
    ##################################################
    ../../modules/server/br0-domaPcServer.nix

    ##################################################
    # NSPAWN containers
    ##################################################
    ../../containers/ha-doma/container.nix
    ../../containers/caddy/container.nix
    ../../containers/zigbee2mqtt/container.nix
    ../../containers/jellyfin/container.nix
  ];

  ## =========================
  ## ZÁKLADNÍ NASTAVENÍ
  ## =========================
  networking.hostName = "domaPcServer";
  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "cs_CZ.UTF-8";
  console.keyMap = "cz";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ## =========================
  ## BOOTLOADER
  ## =========================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  ## =========================
  ## UŽIVATEL
  ## =========================
  users.users.gregor = {
    isNormalUser = true;
    initialPassword = "zmenit";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
    ];
  };

  ## =========================
  ## VIDEO DISK (sdb → /video)
  ## =========================
  fileSystems."/video" = {
    device = "/dev/disk/by-uuid/4cf97703-5ef4-43e0-a73a-b1b2fcdc133d";
    fsType = "xfs";
    options = [
      "noatime"
      "nofail"
    ];
  };

  ## =========================
  ## SMART monitoring disků (KRITICKÉ)
  ## =========================
  services.smartd = {
    enable = true;
    autodetect = true;
    notifications.mail.enable = false;
  };

  ## =========================
  ## SSD / NVMe TRIM
  ## =========================
  services.fstrim.enable = true;

  ## =========================
  ## Ochrana paměti (earlyoom)
  ## =========================
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };

  ## =========================
  ## BEZPEČNÉ DEFAULTY
  ## =========================
  networking.firewall.enable = true;
  services.resolved.enable = true;
  networking.useHostResolvConf = false;

  ## =========================
  ## NIXOS KOMPATIBILITA
  ## =========================
  system.stateVersion = "25.11";
}
