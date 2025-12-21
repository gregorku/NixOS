{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";

  # IDENTITA KONTEJNERU
  networking.hostName = "ha-doma";

  # SÍŤOVÉ NASTAVENÍ
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # OPRAVA DNS: Vypne přebírání resolv.conf z hostitele,
  # což vyřeší chybu "Failed assertions"
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  # Nastavení DHCP na virtuálním rozhraní (název začíná na mv-)
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  # ZÁKLADNÍ SLUŽBY
  services.openssh.enable = true;
}
