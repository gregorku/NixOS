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
  # SÍŤOVÉ OBJEVOVÁNÍ (Klíčové pro Wi-Fi tisk a sken)
  # ----------------------
  services.avahi = {
    enable = true;
    nssmdns4 = true;      # Umožní systému najít adresy typu tiskarna.local
    openFirewall = true;  # Automaticky otevře port 5353 UDP pro mDNS
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