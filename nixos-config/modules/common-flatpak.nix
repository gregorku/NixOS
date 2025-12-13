{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  # Přidání Flathub repozitáře
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub \
          https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
