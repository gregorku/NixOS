{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  # ----------------------
  # Přidání Flathub repo
  # ----------------------
  systemd.services.flatpak-repo = {
    description = "Add Flathub repository";

    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig.Type = "oneshot";
    
    # Použijeme 'script', který NixOS spustí v shellu
    script = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # ----------------------
  # Instalace aplikací
  # ----------------------
  systemd.services.flatpak-install = {
    description = "Install Flatpak apps";

    wantedBy = [ "multi-user.target" ];
    after = [
      "flatpak-repo.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];

    serviceConfig.Type = "oneshot";
    
    # Opět čistší zápis přes 'script' místo volání bashe v ExecStart
    script = ''
      ${pkgs.flatpak}/bin/flatpak install -y --noninteractive flathub nz.mega.MEGAsync || true
    '';
  };
}