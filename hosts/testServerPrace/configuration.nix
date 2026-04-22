{ config, lib, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
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

  # LUKS
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/bdf93ac1-e5a0-4099-8f49-00a884378a43";
    preLVM = true;
    keyFile = "/crypto_keyfile.bin";
  };

  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = "/boot/crypto_keyfile.bin";
  };
  # Hostname
  networking.hostName = "nixos-server";
  networking.networkmanager.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true;
    };
  };

  # Základní balíčky
  environment.systemPackages = with pkgs; [
    git
    nano
    curl
    wget
    htop
    mc
  ];

  # Uživatel
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "gregorku";
  };

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "25.11";
}
