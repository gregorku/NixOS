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
  # 🧠 ZFS (pool "tank")
  # ─────────────────────────────────────
  # POZOR: základ řeší server-zfs.nix
  boot.zfs.extraPools = [ "tank" ];

  # ─────────────────────────────────────
  # 🌐 SÍŤ
  # ─────────────────────────────────────
  networking = {
    hostName = "nixos-server";
    networkmanager.enable = true;

    # unikátní pro každý server (SPRÁVNĚ tady)
    hostId = "7a23ccfe";
  };

  # ─────────────────────────────────────
  # 🔐 SSH
  # ─────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true; # zvážit vypnutí později
    };
  };

  # ─────────────────────────────────────
  # 👤 UŽIVATELÉ
  # ─────────────────────────────────────
  users.users = {
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      initialPassword = "gregorku"; # ⚠️ jen pro setup
    };

    gregor = {
      isNormalUser = true;
      description = "Gregor";
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  # ─────────────────────────────────────
  # 🛡 SUDO
  # ─────────────────────────────────────
  security.sudo.wheelNeedsPassword = true;

  # ─────────────────────────────────────
  # 🧾 VERZE SYSTÉMU
  # ─────────────────────────────────────
  system.stateVersion = "25.11";
}