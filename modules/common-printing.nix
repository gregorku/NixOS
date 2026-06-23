{ config, pkgs, ... }:

{
  # ----------------------
  # TISK (CUPS)
  # ----------------------
  services.printing = {
    enable = true;

    drivers = with pkgs; [
      gutenprint
    ];
  };

  # ----------------------
  # SKENER (SANE)
  # ----------------------
  hardware.sane = {
    enable = true;

    extraBackends = with pkgs; [
      sane-airscan
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