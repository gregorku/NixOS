{
  config,
  lib,
  pkgs,
  ...
}: {
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

    # Cockpit
    #../../modules/server/cockpit.nix

    # Incus
    ../../modules/server/incus-bratrmachServer.nix

    # Firewall
    ../../modules/server/firewall/firewall-bratrmachServer.nix

    # Bridge
    ../../modules/server/server-br0.nix

    # Monitoring serveru
    ../../modules/server/monitoringPc.nix
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
  # 🌐 SÍŤ
  # ─────────────────────────────────────

  networking = {
    hostName = "bratrmach-server";

    # Zatím nepoužíváme NetworkManager.
    networkmanager.enable = false;

    # Unikátní ID serveru.
    # Důležité později pro ZFS.
    hostId = "7a23ccfe";
  };

  # ─────────────────────────────────────
  # 🌐 BRIDGE br0
  # ─────────────────────────────────────
  #
  # Fyzické rozhraní tohoto Mini PC je enp2s0.
  #

  server.br0 = {
    enable = true;
    interface = "enp2s0";
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
