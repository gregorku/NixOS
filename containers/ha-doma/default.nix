{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";
  networking.hostName = "ha-doma";

  # SÍŤOVÁNÍ
  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  # 1. KONFIGURACE PODMANU
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # 2. FIX PRO KEYRING
  virtualisation.containers.containersConf.settings = {
    containers = {
      keyring = false;
    };
  };

  # 3. BALÍČKY
  environment.systemPackages = with pkgs; [
    podman-compose
    git
    vim
    nano
    mc
  ];

  # 4. UŽIVATELÉ
  users.users.gregor = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
    openssh.authorizedKeys.keys = [
      "vaše-ssh-klíče"
    ];
  };

  # 5. OPRÁVNĚNÍ PRO DATA
  # Zajistí, že složka /data bude patřit uživateli gregor
  systemd.tmpfiles.rules = [
    "d /data 0755 gregor users -"
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
}
