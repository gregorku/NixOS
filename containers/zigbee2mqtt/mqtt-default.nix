{ config, pkgs, ... }:

{
  ## SÍŤOVÁ KONFIGURACE (Stejná jako u MQTT - pro macvlan nutnost)
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.useHostResolvConf = false; # Vlastní DNS (volitelné)
  services.resolved.enable = true;

  systemd.network.enable = true;
  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
    dhcpV4Config.ClientIdentifier = "mac";
  };
      services.mosquitto = {
        enable = true;
        listeners = [
          {
            address = "0.0.0.0";
            port = 1883;
            # Allow anonymous access (for testing only!)
            omitPasswordAuth = true;                # Skip password checks entirely
            settings = {
              allow_anonymous = true;               # Explicitly enable anonymous (Mosquitto native option)
            };
            # Optional: Add a broad ACL for anonymous clients
            acl = [ "pattern readwrite #" ];        # Allow read/write on all topics
          }
        ];
      };

      networking.firewall.allowedTCPPorts = [ 1883 ];

      system.stateVersion = "24.05";  # Or match your host's version
}