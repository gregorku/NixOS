{ config, pkgs, ... }:

{
  system.stateVersion = "24.05"; [cite: 1]

  # IDENTITA KONTEJNERU
  networking.hostName = "ha-doma"; [cite: 1]

  # SÍŤ – DHCP z LAN přes virtuální rozhraní macvlan
  networking.useNetworkd = true; [cite: 2]
  systemd.network.enable = true; [cite: 2]

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes"; [cite: 3]
  };

  # ZÁKLAD
  services.openssh.enable = true; [cite: 4]
}
