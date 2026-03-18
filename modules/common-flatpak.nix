{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  # ----------------------
  # Přidání Flathub repo
  # ----------------------
  systemd.services.flatpak-repo = {
    description = "Add Flathub repository";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub \
          https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    install = {
      WantedBy = [ "multi-user.target" ];
    };
  };

  # ----------------------
  # Instalace aplikací
  # ----------------------
  systemd.services.flatpak-install = {
    description = "Install Flatpak apps";
    after = [
      "flatpak-repo.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.flatpak}/bin/flatpak install -y --noninteractive flathub \
          nz.mega.MEGAsync || true
      '';
    };

    install = {
      WantedBy = [ "multi-user.target" ];
    };
  };
}