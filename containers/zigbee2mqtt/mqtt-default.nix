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

   # --------------------------------------------------------------
  # Filesystems – the bind‑mounts are declared in the outer
  # `containers.mqtt.bindMounts` attribute, but we expose the paths
  # here so the service can see them.
  # --------------------------------------------------------------
  fileSystems."/var/lib/mosquitto".neededForBoot = true;
  fileSystems."/etc/mosquitto/secrets".neededForBoot = true;

  # --------------------------------------------------------------
  # Users & permissions – Mosquitto runs as its own system user.
  # --------------------------------------------------------------
  users.users.mosquitto = {
    isSystemUser = true;
    group = "mosquitto";
    home = "/var/lib/mosquitto";
  };
  users.groups.mosquitto = {};

  # --------------------------------------------------------------
  # Mosquitto service
  # --------------------------------------------------------------
  services.mosquitto = {
    enable = true;

    # Minimal built‑in configuration – you can extend it via
    # `settings` or `extraConfig` below.
    listeners = [
      {
        port    = 1883;          # plain MQTT
        address = "0.0.0.0";
      }
    ];

    # Example: load password / ACL files that you placed in the
    # read‑only bind‑mount “/etc/mosquitto/secrets”.
    # Uncomment if you actually have those files.
    #
    # extraConfig = ''
    #   password_file /etc/mosquitto/secrets/passwordfile
    #   acl_file      /etc/mosquitto/secrets/aclfile
    # '';

    # If you need TLS, add another listener block with a `tls` sub‑attr:
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

  # --------------------------------------------------------------
  # Systemd tweaks – run Mosquitto as the dedicated user and lock
  # down the service a bit.
  # --------------------------------------------------------------
  systemd.services.mosquitto.serviceConfig = {
    User = "mosquitto";
    Group = "mosquitto";
    ProtectSystem = "full";
    PrivateTmp = true;
  };

  # --------------------------------------------------------------
  # Optional utilities you might want inside the container.
  # --------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    curl
    jq
  ];

  # --------------------------------------------------------------
  # Turn off services we definitely don’t need in a tiny container.
  # --------------------------------------------------------------
  services.openssh.enable = false;
  services.xserver.enable = false;
}