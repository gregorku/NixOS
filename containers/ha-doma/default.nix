{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";

  # Název stroje uvnitř kontejneru
  networking.hostName = "ha-doma";

  # Aktivace síťování pomocí systemd-networkd
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # Nastavení DHCP pro virtuální rozhraní vytvořené přes macvlan
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  # Povolení SSH pro vzdálený přístup do kontejneru
  services.openssh.enable = true;
}
