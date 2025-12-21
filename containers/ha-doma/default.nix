{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";

  ##################################################
  # IDENTITA KONTEJNERU
  ##################################################
  networking.hostName = "ha-doma";

  ##################################################
  # SÍŤ – DHCP z LAN (br0 → host0)
  ##################################################
  networking.useNetworkd = true;
  systemd.network.enable = true;

  systemd.network.networks."host0" = {
    matchConfig.Name = "host0";
    networkConfig.DHCP = "yes";
  };

  ##################################################
  # ZÁKLAD
  ##################################################
  services.openssh.enable = true;
}
