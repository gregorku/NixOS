# ============================================================
# common-appimage.nix
#
# Deklarativně instalované AppImage aplikace.
#
# Aktuálně:
#   - FreeCAD 1.1.3
#
# FreeCAD používáme jako AppImage místo Flatpaku, protože
# Flatpak varianta FreeCAD 1.1.3 má problém s kompatibilitou
# Qt/PySide runtime.
# ============================================================
{pkgs, ...}: let
  freecadSrc = pkgs.fetchurl {
    url = "https://github.com/FreeCAD/FreeCAD/releases/download/1.1.3/FreeCAD_1.1.3-Linux-x86_64-py311.AppImage";

    hash = "sha256-OoU+tp7llfd58iVdv4CnZZJpgdj/aJA87+5N+wOo9e8=";
  };

  # AppImage nejdříve rozbalíme pouze kvůli získání originálního
  # FreeCAD SVG ikony, která je součástí samotného AppImage.
  freecadExtracted = pkgs.appimageTools.extractType2 {
    pname = "freecad";
    version = "1.1.3";
    src = freecadSrc;
  };

  freecad = pkgs.appimageTools.wrapType2 {
    pname = "freecad";
    version = "1.1.3";
    src = freecadSrc;

    extraInstallCommands = ''
      # --------------------------------------------------------
      # FreeCAD ikona
      #
      # Použijeme originální SVG ikonu z rozbaleného AppImage.
      # KDE Plasma ji potom najde přes Icon=org.freecad.FreeCAD.
      # --------------------------------------------------------
      install -Dm444 \
        ${freecadExtracted}/usr/share/icons/hicolor/scalable/apps/org.freecad.FreeCAD.svg \
        $out/share/icons/hicolor/scalable/apps/org.freecad.FreeCAD.svg

      # --------------------------------------------------------
      # .desktop soubor pro KDE Plasma
      # --------------------------------------------------------
      mkdir -p $out/share/applications

      cat > $out/share/applications/org.freecad.FreeCAD.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=FreeCAD
      Comment=Parametrické 3D CAD modelování
      Exec=freecad %U
      Icon=org.freecad.FreeCAD
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
