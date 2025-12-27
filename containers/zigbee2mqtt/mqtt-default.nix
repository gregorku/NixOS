{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";
  networking.hostName = "mqtt-broker";

  ## ========================================================
  ## SÍŤOVÁ KONFIGURACE (DHCP přes macvlan)
  ## ========================================================
  networking.useDHCP = false;
  networking.useNetworkd = true;
  systemd.network.enable = true;

# OPRAVA: Vypnutí sdílení resolv.conf z hostitele
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
    dhcpV4Config.ClientIdentifier = "mac";
  };

  ## ========================================================
  ## MOSQUITTO
  ## ========================================================
  services.mosquitto = {
    enable = true;

    # Použijte `settings` místo `extraConfig` pro novější verze NixOS
    settings = {
      allow_anonymous = false;
      password_file = "/etc/mosquitto/secrets/passwd";
      listener = {
        protocol = "mqtt";
        port = 1883;
        bind_address = "0.0.0.0";
      };
    };
  };
};