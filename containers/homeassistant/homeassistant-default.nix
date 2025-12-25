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

  virtualisation.containers.containersConf.settings = {
    containers.keyring = false;
  };

  # Definice uživatele s fixním UID pro práva na hostiteli
  users.users.homeassistant = {
    uid = 911;
    isSystemUser = true;
    group = "homeassistant";
    extraGroups = [ "dialout" ];
  };
  users.groups.homeassistant.gid = 911;

  services.home-assistant = {
    enable = true;
    configDir = "/config"; # Odpovídá bindMount v container.nix
    openFirewall = true;

    # [cite_start]Načtení YAML/Nix konfigurace [cite: 9]
    config = import ./configuration.nix;

    extraPackages = python3Packages: with python3Packages; [
      psycopg2
    ];
  };
}
