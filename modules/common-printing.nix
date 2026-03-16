{ config, pkgs, ... }:

{
  # ----------------------
  # TISK (CUPS)
  # ----------------------
  services.printing = {
    enable = true;
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
  # Program pro skenování
  # ----------------------
  environment.systemPackages = with pkgs; [
    simple-scan
  ];

  # ----------------------
  # Firewall pro CUPS
  # ----------------------
  networking.firewall.allowedTCPPorts = [ 631 ];
}