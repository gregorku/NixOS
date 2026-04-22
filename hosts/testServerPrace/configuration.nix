{ config, lib, pkgs, ... }: {

# ─────────────────────────────────────

# 📥 IMPORTY

# ─────────────────────────────────────

imports = [
./hardware-configuration.nix
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

# 🧠 ZFS (druhý disk / pool "tank")

# ─────────────────────────────────────

boot.supportedFilesystems = [ "zfs" ];

boot.zfs.package = pkgs.zfs;

boot.zfs.extraPools = [ "tank" ];

fileSystems."/data" = {
device = "tank/data";
fsType = "zfs";
};

# ─────────────────────────────────────

# 🌐 SÍŤ

# ─────────────────────────────────────

networking.hostName = "nixos-server";
networking.networkmanager.enable = true;

# ─────────────────────────────────────

# 🔐 SSH

# ─────────────────────────────────────

services.openssh = {
enable = true;
settings = {
PermitRootLogin = "prohibit-password";
PasswordAuthentication = true;
};
};

# ─────────────────────────────────────

# 📦 BALÍČKY

# ─────────────────────────────────────

environment.systemPackages = with pkgs; [
git
nano
curl
wget
htop
mc
zfs
];

# ─────────────────────────────────────

# 👤 UŽIVATELÉ

# ─────────────────────────────────────

users.users.admin = {
isNormalUser = true;
extraGroups = [ "wheel" "networkmanager" ];
initialPassword = "gregorku";
};

users.users.gregor = {
isNormalUser = true;
description = "Gregor";
extraGroups = [ "wheel" "networkmanager" ];
};

# ─────────────────────────────────────

# 🛡️ SUDO

# ─────────────────────────────────────

security.sudo.wheelNeedsPassword = true;

# ─────────────────────────────────────

# 🧾 VERZE SYSTÉMU

# ─────────────────────────────────────

system.stateVersion = "25.11";
}
