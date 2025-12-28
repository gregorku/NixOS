{ config, pkgs, ... }:

let
  # Stabilní nixpkgs 24.11 pouze pro Home Assistant
  pkgs2411 = import (builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-24.11.tar.gz"
  ) {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
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

  virtualisation.containers.containersConf.settings.containers.keyring = false;

  environment.systemPackages = with pkgs; [
    mc
  ];

  ## =========================
  ## FIREWALL
  ## =========================
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 8123 ];

  users.groups.homeassistant.gid = 911;
  users.users.homeassistant = {
    uid = 911;
    isSystemUser = true;
    group = "homeassistant";
    extraGroups = [ "dialout" ];
  };

  services.home-assistant = {
    enable = true;
    package = pkgs2411.home-assistant;
    configDir = "/config";

    config = import ./configuration.nix;

    extraComponents = [
      "hardware"
      "usb"
      "bluetooth"
      "met"
    ];

    extraPackages = python3Packages: with python3Packages; [
      paho-mqtt
      aioesphomeapi
      psycopg2
      gtts
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
