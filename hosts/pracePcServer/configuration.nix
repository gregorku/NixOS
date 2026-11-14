{
  config,
  pkgs,
  ...
}: {
  # ==================================================
  # IMPORTY MODULŮ
  # ==================================================

  imports = [
    # Hardware tohoto serveru
    ./hardware-configuration.nix

    # Common – sdílené moduly
    ../../modules/common-security.nix
    ../../modules/common-server-swap.nix

    # Server – základní moduly
    ../../modules/server/server-apps.nix
    ../../modules/server/server-base.nix

    # Další moduly zapneme postupně po dokončení
    # základní konfigurace serveru.

    # ../../modules/common-snapshots.nix
    # ../../modules/server/cockpit.nix
    # ../../modules/server/incus-domaPcServer.nix
    # ../../modules/server/libvirt.nix
    # ../../modules/server/zfs.nix
    # ../../modules/server/monitoringPc.nix
    # ../../auto-upgrade.nix

    # Síť
    # ../../modules/server/server-br0.nix
    # ../../modules/server/firewall/firewall-domaServerPc.nix
  ];

  # ==================================================
  # INITRD – SÍŤ PRO VZDÁLENÉ ODEMYKÁNÍ LUKS
  # ==================================================
  #
  # Síť se používá pouze během initrd.
  #
  # Server se připojí přímo přes fyzickou síťovou
  # kartu enp5s0. Bridge br0 v initrd neexistuje.
  #
  # IP adresa se získá přes DHCP z MikroTiku.
  #
  # Přístup bude možný přes existující WireGuard
  # spojení do domácí LAN.
  #
  # Není potřeba instalovat WireGuard na server.
  #
  # SSH port: 2223
  #

  boot.initrd.systemd.enable = true;

  boot.initrd.network.enable = true;

  boot.initrd.systemd.network = {
    enable = true;

    networks."10-enp5s0" = {
      matchConfig.Name = "enp5s0";

      networkConfig.DHCP = "ipv4";

      linkConfig.RequiredForOnline = "routable";
    };
  };

  # ==================================================
  # INITRD – SÍŤOVÝ OVLADAČ
  # ==================================================
  #
  # Síťová karta Realtek RTL8111/8168.
  # Ovladač r8169 musí být dostupný již v initrd.

  boot.initrd.availableKernelModules = [
    "r8169"
  ];

  # ==================================================
  # INITRD – SSH VZDÁLENÉ ODEMYKÁNÍ
  # ==================================================
  #
  # SSH server běží již před odemčením systémového
  # disku.
  #
  # Host klíč je samostatný pro initrd.
  #
  # Soubor:
  # /etc/secrets/initrd/ssh_host_ed25519_key
  #
  # Veřejný klíč klienta ntbLenovo je autorizován
  # s příkazem systemctl default.
  #
  # Po připojení přes SSH se zobrazí odemykací
  # prostředí systemd a lze zadat LUKS hesla.
  #

  boot.initrd.network.ssh = {
    enable = true;

    port = 2223;

    hostKeys = [
      "/etc/secrets/initrd/ssh_host_ed25519_key"
    ];

    authorizedKeys = [
      ''command="systemctl default" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMfIgYGdYP31GscJs5Z6JFLHuRV2S9DUykPV2sAx+gB gregor@ntbLenovo''
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
  #
  # UEFI + systemd-boot.
  #
  # EFI oddíl:
  # /boot
  #

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi = {
    canTouchEfiVariables = true;

    efiSysMountPoint = "/boot";
  };

  # ==================================================
  # LUKS – SYSTÉMOVÝ DISK
  # ==================================================
  #
  # Systémový disk:
  # /dev/nvme0n1
  #
  # EFI:
  # /dev/nvme0n1p1
  #
  # LUKS root:
  # /dev/nvme0n1p2
  #
  # LUKS UUID:
  # d17095fa-6356-4828-b6b1-51bd2f83e82f
  #
  # Zařízení cryptroot je již definováno
  # v hardware-configuration.nix.
  #
  # Zde jej znovu nedefinujeme.
  #
  # Odemčení probíhá heslem přes initrd SSH.

  # ==================================================
  # LUKS – ŠIFROVANÝ SWAP
  # ==================================================
  #
  # Swap diskový oddíl:
  # /dev/nvme0n1p3
  #
  # LUKS UUID:
  # cc2f6ae6-8176-441a-9a20-5008546cd138
  #
  # Mapper:
  # /dev/mapper/cryptswap
  #
  # Swap je definován v hardware-configuration.nix.
  # Zde pouze zajistíme jeho odemčení v initrd.

  boot.initrd.luks.devices."cryptswap" = {
    device = "/dev/disk/by-uuid/cc2f6ae6-8176-441a-9a20-5008546cd138";
  };

  # ==================================================
  # ZFS
  # ==================================================
  #
  # Server obsahuje existující ZFS pooly na dalších
  # discích.
  #
  # Při instalaci systémového disku jsme se těchto
  # disků nedotýkali.
  #
  # Automatický import poolů zatím není zapnutý.
  # Nejprve ověříme nový systém a následně nastavíme
  # připojení jednotlivých poolů.

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
  # Síťové rozhraní:
  # enp5s0
  #
  # Zatím bez bridge br0.
  # DHCP zajistí připojení serveru do LAN.
  #
  # Bridge a Incus síť nastavíme později.

  networking = {
    hostName = "pracepcserver";

    networkmanager.enable = false;

    useDHCP = true;

    # Unikátní ZFS hostId tohoto serveru.
    hostId = "4206ae54";

    # DNS resolver spravuje systemd-resolved.
    useHostResolvConf = false;
  };

  services.resolved.enable = true;

  # ==================================================
  # SSH – BĚŽÍCÍ SYSTÉM
  # ==================================================
  #
  # Běžný SSH přístup po nabootování.
  #
  # Root se může přihlásit pouze SSH klíčem.
  # Přihlášení roota heslem je zakázané.
  #
  # Heslové přihlášení běžného uživatele je zatím
  # povolené.

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
  #
  # Verze při první instalaci systému.
  # Při běžných upgradech neměnit.

  system.stateVersion = "26.05";
}
