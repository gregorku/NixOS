{ config, pkgs, ... }:

{
  system.stateVersion = "24.05"; #

  # IDENTITA KONTEJNERU
  networking.hostName = "ha-doma"; #

  # SÍŤ – DHCP z LAN přes macvlan (přemostěno na br0)
  networking.useNetworkd = true; # [cite: 2]
  systemd.network.enable = true; # [cite: 2]

  systemd.network.networks."mv-br0" = {
    matchConfig.Name = "mv-br0";
    networkConfig.DHCP = "yes"; # [cite: 3]
  };

  # ZÁKLAD
  services.openssh.enable = true; # [cite: 4]
}
