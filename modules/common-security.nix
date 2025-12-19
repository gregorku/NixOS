{ config, pkgs, lib, ... }:

{
  networking.firewall.enable = lib.mkDefault false;

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PasswordAuthentication = lib.mkDefault true;
      KbdInteractiveAuthentication = lib.mkDefault true;
      PermitRootLogin = lib.mkDefault "no";
    };
  };

  # Nutné pro Cockpit
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;

  # Realtime (nevadí)
  security.rtkit.enable = true;

  # Hardening
  security.protectKernelImage = true;
}
