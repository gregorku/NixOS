{ config, pkgs, ... }:

{
  xdg.configFile."krdprc".text = ''
    [RDP]
    Enabled=true
    Port=3389
    RequireApprove=false
  '';
  # Vynutíme přepsání krdprc, pokud by už existoval
  xdg.configFile."krdprc".force = true;

  xdg.configFile."kwinrc".text = ''
    [Wayland]
    VirtualOutputs=1
  '';
  # Vynutíme přepsání kwinrc, což vyřeší naši chybu
  xdg.configFile."kwinrc".force = true;
}