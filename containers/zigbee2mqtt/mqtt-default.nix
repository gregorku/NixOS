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
  ## KONTEJNER S MOSQUITTO
  ## ========================================================
  containers.mqtt = {
    autoStart = true;

    # Povolení síťového přístupu
    privateNetwork = false;  # Používáme macvlan, takže privateNetwork by mělo být false, nebo jinak nastaveno.

    # Nastavení síťového rozhraní pro kontejner (přes macvlan)
    # Předpokládám, že hostitel již má nakonfigurovaný macvlan a kontejner bude používat toto rozhraní.
    # V tomto příkladu budeme předpokládat, že kontejner bude mít přístup k síti přes hostitele.

    # Konfigurace služeb uvnitř kontejneru
    config = { config, pkgs, ... }: {
      services.mosquitto = {
        enable = true;
        extraConfig = ''
          allow_anonymous false
          password_file /etc/mosquitto/secrets/passwd
          listener 1883 0.0.0.0
        '';
      };

      # Zde bychom mohli vložit soubor s hesly pomocí environment.etc
      # Toto je jen příklad, v praxi bychom heslo neměli ukládat přímo v Nix konfiguraci.
      # Můžeme použít například sops-nix nebo jiný způsob pro citlivá data.
      environment.etc."mosquitto/secrets/passwd" = {
        # Text souboru s hesly. Pozor: toto se uloží do Nix store!
        # Lepší by bylo použít například `deployment.keys` v NixOps.
        text = ''
          user1:$6$rounds=656000$W0Rldsadjhfuiahf$JZ5c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6c9JY6
        '';
        # Můžeme také použít source k načtení ze souboru, který není v Nix store.
        # source = /path/to/passwd; # Toto by byl soubor na hostiteli, který se zkopíruje do kontejneru.
        mode = "0600";
        user = "mosquitto";
        group = "mosquitto";
      };
    };
  };
}