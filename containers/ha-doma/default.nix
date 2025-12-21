{ config, pkgs, ... }:

{
  system.stateVersion = "25.05";

  ## =========================
  ## ZÁKLAD
  ## =========================
  networking.hostName = "ha-doma";
  time.timeZone = "Europe/Prague";

  ## =========================
  ## SSH
  ## =========================
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    # vlož sem svůj SSH public key
  ];

  ## =========================
  ## BALÍKY
  ## =========================
  environment.systemPackages = with pkgs; [
    bash
    curl
    git
    vim
    nano
    mc
  ];
}
