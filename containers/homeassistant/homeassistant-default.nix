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

  environment.systemPackages = with pkgs; [
    mc
  ];
  ## =========================
  ## FIREWALL
  ## =========================
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 8123 ];

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
     ];

  extraPackages = python3Packages: [
      python3Packages.psycopg2
      python3Packages.gtts
      python3Packages.pymetno
      python3Packages.home-assistant-chip-clusters
      python3Packages.universal-silabs-flasher
      python3Packages.zha-quirks             # Knihovna pro specifická zařízení
      python3Packages.zha                    # Samotná knihovna ZHA
      python3Packages.zigpy-znp              # Pokud byste někdy přešel na TI čip (pro jistotu)
      python3Packages.zigpy-deconz           # Pro podporu různých adaptérů
    ];
  };
}
