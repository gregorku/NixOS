{ config, pkgs, ... }:

{
  system.stateVersion = "24.05"; [cite_start]# [cite: 1]

  networking.hostName = "ha-doma"; [cite_start]# [cite: 1]

  # [cite_start]Síťové nastavení uvnitř kontejneru [cite: 2]
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # Nastavíme DHCP na rozhraní, které vytvořil macvlan
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  services.openssh.enable = true; [cite_start]# [cite: 4]
}
