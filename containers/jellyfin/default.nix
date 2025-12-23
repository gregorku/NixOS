{ config, pkgs, ... }:

{
  system.stateVersion = "24.05";
  networking.hostName = "jellyfin";

  ## =========================
  ## SÍŤ – macvlan (mv-*)
  ## =========================
  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  ## =========================
  ## FIX PRO KEYRING – ponecháno
  ## =========================
  virtualisation.containers.containersConf.settings = {
    containers = {
      keyring = false;
    };
  };

  ## =========================
  ## BALÍČKY
  ## =========================
  environment.systemPackages = with pkgs; [
    git vim nano mc
  ];

  ## =========================
  ## UŽIVATEL
  ## =========================
  users.users.gregor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "vaše-ssh-klíče"
    ];
  };

  ## =========================
  ## JELLYFIN SERVER
  ## =========================
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin = {
    isSystemUser = true;
    group = "jellyfin";
    home = "/var/lib/jellyfin";
    createHome = true;
  };
  users.groups.jellyfin = {};

  ## =========================
  ## OPRÁVNĚNÍ PRO DATA
  ## =========================
  systemd.tmpfiles.rules = [
    "d /data 0755 jellyfin jellyfin -"
    "d /data/media 0755 jellyfin jellyfin -"
  ];

  ## =========================
  ## FIREWALL
  ## =========================
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 8096 ];

  ## =========================
  ## SSH
  ## =========================
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
}
