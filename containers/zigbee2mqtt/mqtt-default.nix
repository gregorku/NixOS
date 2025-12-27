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

    # --------------------------------------------------------------------
  # Services – Mosquitto
  # --------------------------------------------------------------------
  services.mosquitto = {
    enable = true;

    # The default config works fine, but we point it to the mounted
    # secrets directory for passwords / ACL files.
    configFile = "/etc/mosquitto/mosquitto.conf";

    # Optional: listen only on the container’s interface.
    listeners = [
      {
        port = 1883;
        address = "0.0.0.0";
      }
    ];

    # If you want TLS, uncomment and adjust the paths (they will be
    # read from the mounted secrets directory):
    #
    # listeners = [
    #   {
    #     port = 8883;
    #     address = "0.0.0.0";
    #     tls = {
    #       certfile = "/etc/mosquitto/secrets/server.crt";
    #       keyfile  = "/etc/mosquitto/secrets/server.key";
    #     };
    #   }
    # ];
  };

  # --------------------------------------------------------------------
  # Filesystem – mount points that you declared in the outer config.
  # --------------------------------------------------------------------
  # The bind mounts are already defined in the container declaration,
  # but we expose the paths here so the services can see them.
  fileSystems."/var/lib/mosquitto".neededForBoot = true;
  fileSystems."/etc/mosquitto/secrets".neededForBoot = true;

  # --------------------------------------------------------------------
  # Users & Permissions
  # --------------------------------------------------------------------
  users.users.mosquitto = {
    isSystemUser = true;
    group = "mosquitto";
    home = "/var/lib/mosquitto";
  };
  users.groups.mosquitto = {};

  # Ensure the data directory is owned by the mosquitto user.
  systemd.services.mosquitto.serviceConfig = {
    User = "mosquitto";
    Group = "mosquitto";
    ProtectSystem = "full";
    PrivateTmp = true;
  };

  # --------------------------------------------------------------------
  # Miscellaneous – keep the container lightweight.
  # --------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    # Optional utilities you might find handy inside the container.
    curl
    jq
  ];

  # Disable unnecessary services that would otherwise start in a full
  # NixOS system.
  services.openssh.enable = false;
  services.xserver.enable = false;
}