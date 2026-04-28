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
    ../../modules/server/server-zfs.nix
    ../../modules/server/cockpit.nix
    ../../modules/server/incus.nix
    ../../modules/server/firewall.nix
    ../../modules/server/server-br0.nix
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
    keyFile = "/crypto_keyfile.bin";
  };

  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = "/boot/crypto_keyfile.bin";
  };

  # ─────────────────────────────────────
  # 🧠 ZFS
  # ─────────────────────────────────────
  boot.zfs.extraPools = [ "zfs-pool-incus" ];

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

  ##################################################
  # Cockpit settings - přepsat výchozí
  ##################################################
  services.cockpit.settings.WebService = {
    AllowUnencrypted = true;
    Origins = lib.mkForce "*";
  };

  # ─────────────────────────────────────
  # 🧾 VERZE SYSTÉMU
  # ─────────────────────────────────────
  system.stateVersion = "25.11";
}