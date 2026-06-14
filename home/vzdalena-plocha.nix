# vzdalena-plocha.nix (home-manager)
# Konfigurace KRDP pro uživatele – nativní KDE Wayland RDP server
# Použití v home.nix: imports = [ ./vzdalena-plocha.nix ];

{ config, pkgs, ... }:

{
  # KRDP konfigurace
  xdg.configFile."krdprc" = {
    force = true;
    text = ''
      [RDP]
      Enabled=true
      Port=3389
      RequireApprove=false
      RequirePassword=false
      CertificatePath=${config.home.homeDirectory}/.local/share/krdp/tls.crt
      PrivateKeyPath=${config.home.homeDirectory}/.local/share/krdp/tls.key
    '';
  };

  # KWin – povolit virtuální výstup a KRDP plugin pro RDP session
  xdg.configFile."kwinrc" = {
    force = true;
    text = ''
      [Wayland]
      VirtualOutputs=1

      [Plugins]
      krdpEnabled=true
    '';
  };

  # Spustit krdpserver automaticky při přihlášení do KDE
  systemd.user.services.krdp = {
    Unit = {
      Description = "KDE RDP Server";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.krdp}/bin/krdpserver -u ${config.home.username} -p tvoje-heslo --plasma --monitor 0 --certificate ${config.home.homeDirectory}/.local/share/krdp/tls.crt --certificate-key ${config.home.homeDirectory}/.local/share/krdp/tls.key";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
