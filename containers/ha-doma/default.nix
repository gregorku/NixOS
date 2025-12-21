{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";

  # IDENTITA KONTEJNERU
  networking.hostName = "ha-doma";

  # SÍŤOVÉ NASTAVENÍ (ponecháno beze změn)
  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  # 1. VYTVOŘENÍ UŽIVATELE GREGOR
  users.users.gregor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Povolení sudo pro správu
    # Ponechání možnosti přihlášení klíčem
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3Nza... váš_klíč ... uživatel@notebook"
    ];
  };

  # 2. NASTAVENÍ SSH PRO PŘIPOJENÍ PŘES HESLO
  services.openssh = {
    enable = true;
    settings = {
      # Povolení přihlášení heslem
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      # Rootovi přístup zakážeme, budeme používat uživatele gregor
      PermitRootLogin = "no";
    };
  };
}
