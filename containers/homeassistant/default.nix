{ config, pkgs, ... }:

{
  systemd.services."systemd-nspawn@homeassistant" = {
    description = "Systemd-nspawn Container homeassistant";

    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.systemd}/bin/systemd-nspawn \
          --quiet \
          --boot \
          --machine=homeassistant \
          --directory=/var/lib/containers/homeassistant"
      ];
      KillMode = "mixed";
      Type = "notify";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
