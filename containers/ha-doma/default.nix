{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";

  ## =========================
  ## ZÁKLAD
  ## =========================
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
