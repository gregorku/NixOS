{ config, pkgs, ... }:

{
  system.stateVersion = "25.11";
  networking.hostName = "homeassistant";

  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  # macvlan rozhraní Shelly broadcast
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig = {
      DHCP = "yes";
      MulticastDNS = true;
      LLMNR = true;
    };
  };

  virtualisation.containers.containersConf.settings = {
    containers.keyring = false;
  };

  environment.systemPackages = with pkgs; [
    mc
    iproute2
    tcpdump
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
      # Základní a DB moduly
      psycopg2
      gtts
      paho-mqtt
      cryptography
      aioesphomeapi
      zeroconf
      
      # Opravené názvy balíčků z vašich logů:
      # Poznámka: Pokud balíček v Nixu neexistuje, musíme ho vynechat nebo najít správný název
      androidtvremote2
      pyipp
      brother
      pyheos
      
      # OPRAVA: philips_js používá v nixpkgs název 'haphilipsjs' nebo podobný, 
      # pokud hlásí undefined, zkuste použít pkgs.python3Packages.haphilipsjs 
      # nebo jej prozatím zakomentujte, pokud rebuild selže.
      # haphilipsjs 

      # Ostatní vaše balíčky
      pymetno
      home-assistant-chip-clusters
      universal-silabs-flasher
      zha-quirks
      zha
      zigpy-znp
      zigpy-deconz
      bellows
      zigpy
    ];
  };
}
