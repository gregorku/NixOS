{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # --- základní serverové moduly (už existují)
    ../../modules/common-security.nix
    ../../modules/common-snapshots.nix
    ../../modules/common-swap.nix

    # --- virtual / VM only
    ../../modules/common-vm-guest.nix
  ];

  networking.hostName = "testServer";

  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "cs_CZ.UTF-8";


  # POVINNÉ – po instalaci už NEMĚNIT
  system.stateVersion = "25.05";
}
