{ config, pkgs, lib, ... }:

{
  # Změnit na mkDefault true pro server
  networking.firewall.enable = lib.mkDefault true;

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PasswordAuthentication = lib.mkDefault true;
      KbdInteractiveAuthentication = lib.mkDefault true;
      PermitRootLogin = lib.mkDefault "no";
    };
  };

  services.dbus.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  security.rtkit.enable = true;
  security.protectKernelImage = true;
}
