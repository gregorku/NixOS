{ config, pkgs, ... }:

{
  # ZÁKLAD – opravdu jen minimum
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    nano
    rsync
    htop
    mc
    zfs
  ];
}