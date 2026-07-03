{ lib, ... }:

{
  # ─────────────────────────────────────
  # 🔐 Initrd SSH Unlock
  # ─────────────────────────────────────
  #
  # Univerzální modul pro vzdálené odemykání LUKS přes SSH.
  #
  # Modul:
  #   • zapne síť v initrd
  #   • zapne SSH server v initrd
  #   • nastaví port SSH
  #   • použije vlastní host key
  #   • umožní definovat více autorizovaných klíčů
  #
  # Modul záměrně NEobsahuje:
  #   • konfiguraci síťového rozhraní
  #   • DHCP
  #   • statickou IP
  #   • bridge
  #
  # Tyto hodnoty jsou závislé na konkrétním stroji
  # a nastavují se v configuration.nix daného hostitele.
  #
  # Samotné odemykání LUKS (keyFile nebo passphrase)
  # zůstává v configuration.nix.
  #

  boot.initrd.systemd.enable = true;
  boot.initrd.network.enable = true;

  boot.initrd.network.ssh = {
    enable = true;

    #
    # Port SSH serveru v initrd
    #
    port = lib.mkDefault 2223;

    #
    # Host key initrd SSH serveru.
    #
    # Vygenerování:
    #
    #   sudo mkdir -p /etc/secrets/initrd-ssh
    #
    #   sudo ssh-keygen \
    #     -t ed25519 \
    #     -f /etc/secrets/initrd-ssh/ssh_host_ed25519_key \
    #     -N ""
    #
    hostKeys = [
      "/etc/secrets/initrd-ssh/ssh_host_ed25519_key"
    ];

    #
    # Seznam veřejných SSH klíčů,
    # které smějí přistupovat do initrd.
    #
    authorizedKeys = [

      # VPS
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNp2SoswZLY/AkmKQO0Prp1wPra0ppuTt74oWQMCSFM luks-unlock"

      # Notebook
      # "ssh-ed25519 AAAA... unlock-ntbLenovo"

      # Pracovní PC
      # "ssh-ed25519 AAAA... unlock-pracovniPc"

    ];
  };
}