{ config, pkgs, lib, ... }:

{
  system.stateVersion = "24.05"; # Doporučuji použít stabilní verzi, pokud nejsi na unstable
  networking.hostName = "caddy";

  # Musíme povolit networkd, aby tvá konfigurace níže fungovala
  networking.useNetworkd = true;
  networking.useDHCP = false; # Globální DHCP vypneme, řešíme ho per-interface

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
    # Důležité pro kontejnery, aby DHCP klient nezahodil konfiguraci při čekání
    linkConfig.RequiredForOnline = "routable";
  };

  services.caddy = {
    enable = true;
    virtualHosts."homeassistant.serveftp.org".extraConfig = ''
      reverse_proxy 192.168.100.230:8123
    '';
  };
}
