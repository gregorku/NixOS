{ config, pkgs, ... }:

{
  # ----------------------
  # TISK (CUPS)
  # ----------------------
  services.printing = {
    enable = true;

    drivers = with pkgs; [
      brlaser
    ];
  };

  # ----------------------
  # SKENER (SANE)
  # ----------------------
  hardware.sane = {
    enable = true;

    extraBackends = with pkgs; [
      brscan4
    ];
  };

  # ----------------------
  # Firewall pro CUPS
  # ----------------------
  networking.firewall.allowedTCPPorts = [ 631 ];
}