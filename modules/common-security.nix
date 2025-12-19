{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [];
  };

  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Needed for PipeWire (realtime scheduling)
  security.rtkit.enable = true;

  # Hardening
  security.protectKernelImage = true;
}
