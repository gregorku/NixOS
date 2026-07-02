{ config, lib, pkgs, ... }:

{
  # ─────────────────────────────────────
  # 🔐 Initrd SSH Unlock
  # ─────────────────────────────────────
  #
  # Tento modul připravuje vzdálené odemykání LUKS
  # přes SSH ještě před připojením root filesystemu.
  #
  # Podporuje:
  #   • více VPS serverů
  #   • více administrátorských klíčů
  #   • WireGuard/OpenVPN za routerem
  #   • statickou i DHCP konfiguraci
  #
  # Poznámka:
  #   Samotné odemykání LUKS (keyFile nebo passphrase)
  #   zůstává v configuration.nix.
  #

  boot.initrd.systemd.enable = true;

  boot.initrd.network.enable = true;

  #
  # Síť
  #
  # Výchozí nastavení používá DHCP.
  # Pro jednotlivé servery lze přepsat v configuration.nix.
  #
  boot.initrd.network.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  #
  # SSH server v initrd
  #
  boot.initrd.network.ssh = {
    enable = true;

    port = lib.mkDefault 2223;

    #
    # Host key initrd SSH serveru.
    #
    hostKeys = [
      "/etc/secrets/initrd-ssh/ssh_host_ed25519_key"
    ];

    #
    # Seznam administrátorských klíčů.
    #
    authorizedKeys = [

      # VPS
      # "ssh-ed25519 AAAA... unlock-vps"

      # Notebook
      # "ssh-ed25519 AAAA... unlock-ntbLenovo"

      # Workstation
      # "ssh-ed25519 AAAA... unlock-pracovniPc"

    ];
  };
}