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

  services.dbus.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  security.rtkit.enable = true;
  security.protectKernelImage = true;
}
