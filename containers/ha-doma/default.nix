{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";

  networking.hostName = "ha-doma";

  # Síťování (ponecháno beze změn)
  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  # 1. AKTIVACE PODMANU UVNITŘ KONTEJNERU
  virtualisation.podman = {
    enable = true;
    # Vytvoří alias 'docker' pro příkaz 'podman'
    dockerCompat = true;
    # Potřebné pro DNS mezi vnořenými kontejnery
    defaultNetwork.settings.dns_enabled = true;

  };

  # 2. GLOBÁLNÍ PROMĚNNÉ PROSTŘEDÍ (oprava chyby)
  # Musí být mimo blok virtualisation.podman
    environment.variables = {
      PODMAN_RUN_IGNORE_KEYRING = "1";
  };

  # 3. INSTALACE PODMAN-COMPOSE A DALŠÍCH NÁSTROJŮ
  environment.systemPackages = with pkgs; [
    podman-compose
    git
    vim # pro editaci compose souborů přímo v kontejneru
    nano
    mc
  ];

  # Uživatelská sekce (ponecháno pro uživatele gregor)
  users.users.gregor = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ]; # Přidána skupina podman
    openssh.authorizedKeys.keys = [
      "vaše-ssh-klíče"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
}
