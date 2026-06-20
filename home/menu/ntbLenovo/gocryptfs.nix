{ ... }:

{

# =========================

# Kategorie Gocryptfs

# =========================

home.file.".local/share/desktop-directories/gocryptfs-desktop.directory".text = ''
[Desktop Entry]
Type=Directory
Name=Gocryptfs
Icon=cr-key
'';

# =========================

# Gocryptfs Dokumenty
# =========================

home.file.".local/share/applications/gocryptfs-dokumenty.directory.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=kamera ložnice
Exec=/home/gregor/.ssh/gocryptfs/gocryptfs-dokumenty.sh
Icon=cr-key
Terminal=false
StartupNotify=true
'';

# =========================

# Gocryptfs Dokumenty odpojení

# =========================

home.file.".local/share/applications/gocryptfs-dokumenty-odpojeni.directory.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=kamera obývák
Exec=/home/gregor/.ssh/gocryptfs/gocryptfs-dokumenty-odpojeni.sh
Icon=cr-key
Terminal=false
StartupNotify=true
'';

# =========================

# Gocryptfs Data

# =========================

home.file.".local/share/applications/gocryptfs-data.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=kamera 3D print
Exec=/home/gregor/.ssh/gocryptfs/gocryptfs-data.sh
Icon=cr-key
Terminal=false
StartupNotify=true
'';

# =========================

# Gocryptfs Data odpojení

# =========================

home.file.".local/share/applications/gocryptfs-data-odpojeni.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=Práce PC dílna
Exec=/home/gregor/.ssh/gocryptfs/gocryptfs-data-ospojeni.sh
Icon=cr-key
Terminal=false
StartupNotify=true
'';
}
