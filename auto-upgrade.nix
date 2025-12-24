{ config, pkgs, ... }:

{
  systemd.services.nixos-auto-upgrade = {
    description = "NixOS automatic rebuild from git (flake)";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/etc/nixos";
      ExecStart = ''
        ${pkgs.git}/bin/git pull
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake /etc/nixos#domaPcServer
      '';
    };
  };

  systemd.timers.nixos-auto-upgrade = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun 03:00";
      Persistent = true;
    };
  };
}
