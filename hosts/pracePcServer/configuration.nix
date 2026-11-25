{
  config,
  lib,
  pkgs,
  ...
}: {
  # ==================================================
  # IMPORTY MODULŮ
  # ==================================================

  imports = [
    ./hardware-configuration.nix
    ../../modules/common-security.nix
    ../../modules/common-server-swap.nix
    ../../modules/server/server-apps.nix
    ../../modules/server/server-base.nix

    # ../../modules/common-snapshots.nix
    # ../../modules/server/cockpit.nix
    #../../modules/server/incus-pracePcServer.nix
    # ../../modules/server/libvirt.nix
    # ../../modules/server/zfs.nix

    ../../modules/server/monitoringPc.nix
    # ../../auto-upgrade.nix

    # Síť
    ../../modules/server/server-br0.nix
    # ../../modules/server/firewall/firewall-domaServerPc.nix
  ];

  # ==================================================
  # INITRD – PEVNÁ SÍŤ PRO VZDÁLENÉ ODEMYKÁNÍ LUKS
  # ==================================================
  #
  # Fyzické rozhraní: enp5s0
  # IP adresa:        192.168.12.200/24
  # Brána:            192.168.12.1
  # DNS:              192.168.12.1
  #
  # Tato konfigurace platí pouze pro initrd.
  # Běžící NixOS nadále používá DHCP.
  #
  # Bridge br0 v initrd nepoužíváme.

  boot.initrd.systemd.enable = true;

  boot.initrd.network.enable = true;

  boot.initrd.systemd.network = {
    enable = true;

    networks."10-enp5s0" = {
      matchConfig.Name = "enp5s0";

      address = [
        "192.168.12.200/24"
      ];

      networkConfig = {
        DHCP = "no";
        IPv6AcceptRA = false;
      };

      routes = [
        {
          Gateway = "192.168.12.1";
        }
      ];

      linkConfig.RequiredForOnline = "routable";
    };
  };

  # ==================================================
  # INITRD – SÍŤOVÝ OVLADAČ
  # ==================================================

  boot.initrd.availableKernelModules = [
    "r8169"
  ];

  # ==================================================
  # INITRD – SSH VZDÁLENÉ ODEMYKÁNÍ
  # ==================================================
  #
  # SSH port: 2223
  #
  # Samostatný host klíč:
  # /etc/secrets/initrd/ssh_host_ed25519_key
  #
  # Povolení klienti:
  # - ntbLenovo
  # - pracovniPc

  boot.initrd.network.ssh = {
    enable = true;

    port = 2223;

    hostKeys = [
      "/etc/secrets/initrd/ssh_host_ed25519_key"
    ];

    authorizedKeys = [
      ''command="systemctl default" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMfIgYGdYP31GscJs5Z6JFLHuRV2S9DUykPV2sAx+gB gregor@ntbLenovo''
      ''command="systemctl default" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfQjk/mSjsmoRv98IUCntIJ8BThj0RokyDL0S+yHiAd gregor@pracovniPc''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCFPXT4UYa7s0vRqFQtkBVrG09P0u5I67QM4Efop1n3 netcupVPSServer-LUKS-unlock''
    ];
  };

  # ==================================================
  # ZÁKLADNÍ NASTAVENÍ SYSTÉMU
  # ==================================================

  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "cs_CZ.UTF-8";

  console.keyMap = "cz";

  # ==================================================
  # NIX – FLAKES
  # ==================================================

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # ==================================================
  # BOOTLOADER
  # ==================================================

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # ==================================================
  # LUKS – SYSTÉMOVÝ DISK
  # ==================================================
  #
  # Root LUKS je definován v hardware-configuration.nix.
  #
  # UUID:
  # d17095fa-6356-4828-b6b1-51bd2f83e82f
  #
  # Odemčení probíhá přes initrd SSH.

  # ==================================================
  # ZFS
  # ==================================================

  boot.supportedFilesystems = [
    "zfs"
  ];

  boot.zfs.forceImportRoot = false;

  services.zfs.autoScrub.enable = false;

  services.zfs.autoSnapshot.enable = false;

  # ==================================================
  # SÍŤ – BĚŽÍCÍ SYSTÉM
  # ==================================================
  #
  # Běžný NixOS používá DHCP.
  # Tato konfigurace je nezávislá na initrd.
  #
  # Hostname: pracepcserver

  networking = {
    hostName = "pracepcserver";

    networkmanager.enable = false;

    useDHCP = true;

    hostId = "4206ae54";

    useHostResolvConf = false;
  };

  # DNS resolver
  services.resolved.enable = true;

  # ==================================================
  # LAN BRIDGE br0
  # ==================================================

  server.br0 = {
    enable = true;
    interface = "enp5s0";
  };

  # Pevná MAC adresa bridge (pracepcserver)
  systemd.network.netdevs."40-br0".netdevConfig.MACAddress = "1A:AC:4D:52:1B:A3";

  # ==================================================
  # SSH – BĚŽÍCÍ SYSTÉM
  # ==================================================
  #
  # Standardní SSH port 22.
  # Port 2223 je určen pouze pro initrd.

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "prohibit-password";

      PasswordAuthentication = true;
    };
  };

  # ==================================================
  # MONITORING DISKŮ
  # ==================================================

  services.smartd = {
    enable = true;

    autodetect = true;

    notifications.mail.enable = false;
  };

  # ==================================================
  # SSD / NVMe TRIM
  # ==================================================

  services.fstrim.enable = true;

  # ==================================================
  # OCHRANA PAMĚTI – EARLYOOM
  # ==================================================

  services.earlyoom = {
    enable = true;

    freeMemThreshold = 5;

    freeSwapThreshold = 10;
  };

  # ==================================================
  # UŽIVATELÉ
  # ==================================================

  users.users.gregor = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
    ];
  };

  # ==================================================
  # NIXOS STATE VERSION
  # ==================================================

  system.stateVersion = "26.05";
}
