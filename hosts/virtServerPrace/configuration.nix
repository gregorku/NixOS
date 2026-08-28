{
  config,
  lib,
  pkgs,
  ...
}:

{
  # ─────────────────────────────────────
  # 📥 IMPORTY
  # ─────────────────────────────────────
  imports = [
    ./hardware-configuration.nix

    # ZÁKLAD SERVERU
    ../../modules/server/server-base.nix
    ../../modules/server/server-apps.nix
    ../../modules/server/server-locale.nix

    # ───────────────────────────────────
    # POZDĚJI AKTIVOVAT
    # ───────────────────────────────────

    # ZFS
    #../../modules/server/server-zfs.nix

    # Cockpit
    #../../modules/server/cockpit.nix

    # Incus
    #../../modules/server/incus.nix

    # Firewall
    #../../modules/server/firewall/firewall-testServerPrace.nix

    # Bridge
    ../../modules/server/server-br0.nix

    # Vzdálené odemykání LUKS přes SSH
    #../../modules/security/initrd-unlock.nix

    # Monitoring serveru
    #../../modules/server/monitoringPc.nix
  ];

  # ─────────────────────────────────────
  # 💽 BOOTLOADER
  # UEFI + systemd-boot
  # ─────────────────────────────────────

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # ─────────────────────────────────────
  # 🔐 LUKS2
  # šifrovaný systémový disk
  # ─────────────────────────────────────

  boot.initrd.luks.devices."cryptroot" = {
  device = "/dev/disk/by-uuid/476554ca-6f6b-420a-bc4a-7c056518f086";

  # Automatické odemknutí během ladění.
  # KEYFILE JE NA NEŠIFROVANÉM /boot!
  keyFile = "/boot/cryptroot.key";
  };

  boot.initrd.secrets = {
    "/boot/cryptroot.key" = "/boot/cryptroot.key";
  };

  # ─────────────────────────────────────
  # 🔐 Alternativa – později můžeme použít
  # keyfile pro automatické odemykání
  # ─────────────────────────────────────

  #boot.initrd.secrets = {
  #  "/crypto_keyfile.bin" = "/boot/crypto_keyfile.bin";
  #};

  # ─────────────────────────────────────
  # 🌐 INITRD NETWORK
  # ─────────────────────────────────────
  #
  # Zatím vypnuto.
  #
  # Později použijeme pro vzdálené
  # odemykání LUKS přes SSH.
  #
  # V initrd ještě není br0 ani VLAN.
  # Použije se fyzické síťové rozhraní.
  #

  #boot.initrd.systemd.network.enable = true;

  #boot.initrd.systemd.network.networks."10-initrd-enp1s0" = {
  #  matchConfig.Name = "eno1";

  #  address = [
  #    "192.168.12.230/24"
  #  ];

  #  routes = [
  #    {
  #      Gateway = "192.168.120.1";
  #    }
  #  ];

  #  networkConfig = {
  #    DHCP = "no";
  #  };
  #};

  # ─────────────────────────────────────
  # 💽 ZFS
  # ─────────────────────────────────────
  #
  # Datová ZFS pole budou přidána později.
  #

  #boot.supportedFilesystems = [ "zfs" ];

  #boot.zfs.extraPools = [
  #  "zfs-pool-incus"
  #];

  #boot.zfs.forceImportRoot = false;

  #services.zfs.autoScrub.enable = false;
  #services.zfs.autoSnapshot.enable = false;

  # ─────────────────────────────────────
  # 🌐 SÍŤ
  # ─────────────────────────────────────

  networking = {
    hostName = "virt-server";

    # Zatím nepoužíváme NetworkManager.
    networkmanager.enable = false;

    # Unikátní ID serveru.
    # Důležité později pro ZFS.
    hostId = "7a23ccfe";
  };

  # ─────────────────────────────────────
  # 🌐 Síťový ovladač v initrd
  # ─────────────────────────────────────
  #
  # Zatím není potřeba.
  #
  # Později aktivujeme společně s initrd
  # networking pro vzdálené odemykání LUKS.
  #

  #boot.initrd.availableKernelModules = [
  #  "r8169"
  #];

  # ─────────────────────────────────────
  # 🌐 BRIDGE br0
  # ─────────────────────────────────────
  #
  # Aktivujeme až po ověření skutečného
  # názvu fyzického síťového rozhraní.
  #

  server.br0 = {
    enable = true;
    interface = "eno1";
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
      extraGroups = [
        "wheel"
      ];

      # ⚠️ Pouze dočasně během instalace.
      # Později odstranit.
      initialPassword = "gregorku";
    };

    gregor = {
      isNormalUser = true;
      description = "Gregor";

      extraGroups = [
        "wheel"
      ];
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
