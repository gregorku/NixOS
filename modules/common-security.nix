{ config, pkgs, ... }:

{
  ##################################################
  # Firewall (ve VM pro testování vypnutý)
  ##################################################
  networking.firewall.enable = false;

  ##################################################
  # SSH
  ##################################################
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  ##################################################
  # ZÁKLAD pro Cockpit (POVINNÉ)
  ##################################################

  # System D-Bus
  services.dbus.enable = true;

  # PolicyKit – nutné pro session
  security.polkit.enable = true;

  # AccountsService – Cockpit bez něj padá po loginu
  services.accounts-daemon.enable = true;

  # PAM service pro Cockpit
  security.pam.services.cockpit.enable = true;

  ##################################################
  # Realtime (nevadí)
  ##################################################
  security.rtkit.enable = true;

  ##################################################
  # Hardening
  ##################################################
  security.protectKernelImage = true;
}

