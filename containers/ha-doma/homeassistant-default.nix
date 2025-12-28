{ config, pkgs, ... }:

{
  system.stateVersion = "25.11";
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

  environment.systemPackages = with pkgs; [
    mc
  ];
  ## =========================
  ## FIREWALL
  ## =========================
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 8123 ];

  # ESPHome potřebuje mDNS (Avahi) pro vyhledávání senzorů v síti
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };

  users.users.homeassistant = {
    uid = 911;
    isSystemUser = true;
    group = "homeassistant";
    extraGroups = [ "dialout" ];
  };
  users.groups.homeassistant.gid = 911;

  services.home-assistant = {
    enable = true;
    configDir = "/config";

    config = import ./configuration.nix;

    extraComponents = [
      "hardware"
      "usb"
      "bluetooth"
      "met"
      "esphome" # Explicitně přidáno
      "zeroconf" # Nutné pro mDNS/ESPHome vyhledávání
      "default_config"
      "mqtt"
     ];

  extraPackages = python3Packages: with python3Packages; [
      psycopg2
      gtts
      paho-mqtt
      cryptography
      # Knihovny vyžadované podle vašeho logu:
      androidtvremote2
      pyipp
      haphilipsjs
      brother
      pyheos
      # Doporučené pro ESPHome a Zeroconf (řeší neviditelné hodnoty)
      aioesphomeapi
      zeroconf
    ];
  };
}
