# ============================================================
# common-appimage.nix
#
# Deklarativně instalované AppImage aplikace.
# Aktuálně zde používáme FreeCAD, protože Flatpak verze
# FreeCAD 1.1.3 má problém s Qt/PySide runtime.
# ============================================================
{pkgs, ...}: let
  freecad = pkgs.appimageTools.wrapType2 {
    pname = "freecad";
    version = "1.1.3";

    src = pkgs.fetchurl {
      url = "https://github.com/FreeCAD/FreeCAD/releases/download/1.1.3/FreeCAD_1.1.3-Linux-x86_64-py311.AppImage";

      hash = "sha256-OoU+tp7llfd58iVdv4CnZZJpgdj/aJA87+5N+wOo9e8=";
    };

    extraInstallCommands = ''
      mkdir -p $out/share/applications

      cat > $out/share/applications/freecad.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=FreeCAD
      Comment=Parametrické 3D CAD modelování
      Exec=freecad %U
      Icon=freecad
      Terminal=false
      Categories=Graphics;Science;Engineering;
      StartupNotify=true
      EOF
    '';
  };
in {
  # ------------------------------------------------------------
  # AppImage podpora v NixOS
  # ------------------------------------------------------------
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # ------------------------------------------------------------
  # AppImage aplikace
  # ------------------------------------------------------------
  environment.systemPackages = [
    freecad
  ];
}
