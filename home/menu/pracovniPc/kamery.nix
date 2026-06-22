{ ... }:

{

# =========================

# Kategorie Kamery

# =========================

home.file.".local/share/desktop-directories/kamery-desktop.directory".text = ''
[Desktop Entry]
Type=Directory
Name=Kamery
Icon=camera-video
'';

# =========================

# Kamera ložnice
# =========================

home.file.".local/share/applications/kamera-loznice.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=kamera ložnice
Exec=/home/gregor/.ssh/kamery/kamera-loznice.sh
Icon=camera-video
Terminal=false
StartupNotify=true
'';

# =========================

# Kamera obývák

# =========================

home.file.".local/share/applications/kamera-obyvak.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=kamera obývák
Exec=/home/gregor/.ssh/kamery/kamera-obyvak.sh
Icon=camera-video
Terminal=false
StartupNotify=true
'';

# =========================

# Kamera 3D print

# =========================

home.file.".local/share/applications/kamera-3dprint.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=kamera 3D print
Exec=/home/gregor/.ssh/kamery/kamera-3dprint.sh
Icon=camera-video
Terminal=false
StartupNotify=true
'';

# =========================

# Práce PC dílna

# =========================

home.file.".local/share/applications/pracePc.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=Práce PC dílna
Exec=/home/gregor/.ssh/vzdalena-plocha/prace-pracePc-win11-rdp.sh
Icon=krdc
Terminal=false
StartupNotify=true
'';
}
