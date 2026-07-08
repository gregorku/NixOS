{ config, lib, pkgs, ... }:

{
  # ─────────────────────────────────────
  # 📥 IMPORTY
  # ─────────────────────────────────────
  imports = [
    ./hardware-configuration.nix

    # server moduly
    ../../modules/server/server-base.nix
    ../../modules/server/server-apps.nix
    ../../modules/server/server-locale.nix
    #../../modules/server/server-zfs.nix
    ../../modules/server/cockpit.nix
    ../../modules/server/incus.nix
    ../../modules/server/firewall/firewall-testServerPrace.nix
    ../../modules/server/server-br0.nix
    ../../modules/security/initrd-unlock.nix
  ];

  # ─────────────────────────────────────
  # 💽 BOOTLOADER (UEFI + GRUB + LUKS)
  # ─────────────────────────────────────
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  # ─────────────────────────────────────
  # 🔐 LUKS (šifrovaný root)
  # ─────────────────────────────────────
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/bdf93ac1-e5a0-4099-8f49-00a884378a43";
    preLVM = true;
  #  keyFile = "/crypto_keyfile.bin";
  };

  #boot.initrd.secrets = {
  #  "/crypto_keyfile.bin" = "/boot/crypto_keyfile.bin";
  #};

  # ─────────────────────────────────────
  # 🌐 Initrd network
  # ─────────────────────────────────────
  #
  # Síť používaná v initrd ještě před připojením
  # šifrovaného root filesystemu.
  #
  # Slouží pro vzdálené odemykání LUKS přes SSH.
  #
  # V initrd ještě neexistují bridge (br0), VLAN ani
  # další virtuální rozhraní. Používá se vždy fyzické
  # síťové rozhraní.
  #
  # Pro servery je doporučeno použít statickou IP,
  # aby byl initrd dostupný i při výpadku DHCP.
  #
  # Po spuštění běžného systému převezme konfiguraci
  # standardní networking NixOS (např. bridge br0
  # s DHCP nebo statickou IP).
  #

  #
  # Síť používaná pouze během initrd pro
  # vzdálené odemykání LUKS přes SSH.
  #
  # Po přechodu do běžného systému tato
  # konfigurace zanikne a síť převezme
  # standardní konfigurace serveru.
  #
  boot.initrd.systemd.network.enable = true;

  boot.initrd.systemd.network.networks."10-initrd-enp1s0" = {
    matchConfig.Name = "enp1s0";

    address = [
      "192.168.220.100/24"
    ];

    routes = [
      {
        Gateway = "192.168.220.1";
      }
    ];

    networkConfig = {
      DHCP = "no";
    };
  };

  ## =========================
  ## ZFS – import datapool po bootu
  ## =========================
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zfs-pool-incus" ]; # Explicitní import
  boot.zfs.forceImportRoot = false; # Doporučeno od NixOS 26.11

  services.zfs.autoScrub.enable = false;
  services.zfs.autoSnapshot.enable = false;

  # ─────────────────────────────────────
  # 🌐 SÍŤ
  # ─────────────────────────────────────
  networking = {
    hostName = "nixos-server";

    # ❗ vypnout NetworkManager (nutné pro bridge)
    networkmanager.enable = false;

    # unikátní pro každý server
    hostId = "7a23ccfe";
  };

  # ─────────────────────────────────────
  # 🌐 Síťový ovladač v initrd
  # ─────────────────────────────────────
  #
  # Síťová karta enp1s0 používá ovladač r8169.
  # Ovladač musí být dostupný už v initrd,
  # aby bylo možné použít síť pro vzdálené
  # odemykání LUKS přes SSH.
  #
  boot.initrd.availableKernelModules = [
    "r8169"
  ];

  # ----------------------
  # Bridge br0 (LAN)
  # ----------------------
  server.br0 = {
    enable = true;
    interface = "enp1s0";  # uprav podle serveru
  };

  # ─────────────────────────────────────
  # 🔐 SSH
  # ─────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true; # později vypnout
    };
  };

  # ─────────────────────────────────────
  # 👤 UŽIVATELÉ
  # ─────────────────────────────────────
  users.users = {
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "gregorku"; # ⚠️ jen dočasně
    };

    gregor = {
      isNormalUser = true;
      description = "Gregor";
      extraGroups = [ "wheel" ];
    };
  };

  # ─────────────────────────────────────
  # 🛡 SUDO
  # ─────────────────────────────────────
  security.sudo.wheelNeedsPassword = true;

  # ─────────────────────────────────────
  # 🧾 VERZE SYSTÉMU
  # ─────────────────────────────────────
  system.stateVersion = "26.05";
}