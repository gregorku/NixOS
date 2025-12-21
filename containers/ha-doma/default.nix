{ config, pkgs, ... }:

{
  system.stateVersion = "24.05"; [cite: 1]

  networking.hostName = "ha-doma"; [cite: 1]

  # Kontejner nepotřebuje vlastní networkd, pokud ho řídí nspawn,
  # ale pro DHCP v rámci bridge je to takto správně:
  networking.useNetworkd = true; [cite: 2]
  systemd.network.enable = true; [cite: 2]

  systemd.network.networks."10-eth0" = {
    matchConfig.Name = "eth0";
    networkConfig.DHCP = "yes";
  };

  services.openssh.enable = true; [cite: 4]
}
