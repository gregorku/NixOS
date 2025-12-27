{ config, pkgs, ... }:

{
  # Verze stavu systému uvnitř kontejneru
  system.stateVersion = "24.05";

  # Název hostitele uvnitř kontejneru
  networking.hostName = "zigbee2mqtt";

  ## ========================================================
  ## SÍŤOVÁ KONFIGURACE (systemd-networkd + DHCP přes macvlan)
  ## ========================================================
  
  # Vypneme výchozí skriptované síťování
  networking.useDHCP = false;
  networking.useNetworkd = true;

  # Použijeme vlastní DNS řešitel (nezávislý na hostiteli)
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  # Povolíme networkd pro správu rozhraní
  systemd.network.enable = true;

  # Konfigurace pro macvlan rozhraní (v nspawn začínají "mv-")
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig = {
      DHCP = "yes";
      IPv6AcceptRA = true;
    };
    # Identifikace pomocí MAC adresy bývá pro DHCP servery v routerech stabilnější
    dhcpV4Config.ClientIdentifier = "mac";
  };

  # Firewall - otevření portu pro webové rozhraní
  networking.firewall.allowedTCPPorts = [ 8080 ];

  ## ========================================================
  ## SLUŽBA ZIGBEE2MQTT
  ## ========================================================

  services.zigbee2mqtt = {
    enable = true;
    
    # Nastavení datové složky (odpovídá tvému bindMount "/data")
    dataDir = "/data";

    settings = {
      # Sériový port - používáme alias z bindMounts
      serial = {
        port = "/dev/zigbee";
        # Pro čip EFR32MG24 (SMLIGHT SLZB-07) je doporučen driver "ember"
        # Pokud by verze Z2M v NixOS byla starší, použij "ezsp"
        adapter = "ember"; 
      };

      # NAČTENÍ EXTERNÍ KONFIGURACE (Sekrety mimo Git)
      # Tento řádek vloží obsah souboru mqtt-secrets.yaml (server, user, password) do této sekce
      # Soubor musí být v kontejneru dostupný v cestě /data/mqtt-secrets.yaml
      # V Nixu musíme použít speciální zápis pro klíč začínající vykřičníkem
      "${"!include"}" = "mqtt-secrets.yaml";

      # Webové rozhraní
      frontend = {
        port = 8080;
        host = "0.0.0.0"; # Naslouchat na všech rozhraních kontejneru
      };

      # Základní chování
      permit_join = false;
      homeassistant = true;
    };
  };

  # Oprava práv pro přístup k sériovému portu uvnitř kontejneru
  # (I když je device namapován, uživatel pod kterým běží z2m k němu musí mít přístup)
  users.users.zigbee2mqtt.extraGroups = [ "dialout" ];
}