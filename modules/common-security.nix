{ config, pkgs, ... }:

{
  networking.firewall.enable = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
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
