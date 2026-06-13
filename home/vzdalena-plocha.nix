{ config, pkgs, ... }:

{
  # Deklarativní nastavení pro nativní RDP v KDE Plasma 6
  xdg.configFile."krdprc".text = ''
    [RDP]
    # Automatické spuštění serveru po přihlášení
    Enabled=true
    # Port, na kterém krdp naslouchá (necháváme standardní)
    Port=3389
    # Bezpečnost: Zakázání výzvy k potvrzení na monitoru v kanceláři
    RequireApprove=false
  '';

  # Volitelné: Ujistíme se, že KWin (Wayland) správně spolupracuje s PipeWire pro sdílení obrazu
  xdg.configFile."kwinrc".text = ''
    [Wayland]
    # Aktivuje podporu pro virtuální výstupy a vzdálené sdílení
    VirtualOutputs=1
  '';
}