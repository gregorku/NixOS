{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";

  networking.hostName = "homeassistant";
  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  # KEYRING FIX
  virtualisation.containers.containersConf.settings = {
    containers.keyring = false;
  };

  services.openssh.enable = true;

  # Nastavíme fixní GID a UID, abychom mohli nastavit práva na hostiteli
  users.groups.homeassistant.gid = 911;

  users.users.homeassistant = {
    uid = 911;
    isSystemUser = true;
    group = "homeassistant";
    extraGroups = [ "dialout" ];
    home = "/var/lib/homeassistant";
    createHome = true;
  };

  networking.firewall.allowedTCPPorts = [ 8123 ];

  services.home-assistant = {
    enable = true;
    configDir = "/data/homeassistant/config";
    openFirewall = true;

    # ZDE BÝVALA CHYBA: Nyní načítáme configuration.nix
    config = import ./configuration.nix;

    extraPackages = python3Packages: with python3Packages;
    [
      psycopg2
    ];
  };
}
