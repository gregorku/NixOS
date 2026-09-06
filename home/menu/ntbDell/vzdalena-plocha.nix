{ ... }:

{

# =========================

# Kategorie Vzdálená plocha

# =========================

home.file.".local/share/desktop-directories/remote-desktop.directory".text = ''
[Desktop Entry]
Type=Directory
Name=Vzdálená plocha
Icon=krdc
'';

# =========================

# Pracovní PC kancelář

# =========================

home.file.".local/share/applications/pracovniPc.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=Pracovní PC kancelář
Comment=RDP připojení na pracovní počítač
Exec=/home/gregor/.ssh/vzdalena-plocha/prace-pracovniPc-rdp.sh
Icon=krdc
Terminal=false
StartupNotify=true
'';

# =========================

# Služební PC

# =========================

home.file.".local/share/applications/sluzebniPc.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=Služební PC kancelař
Exec=/home/gregor/.ssh/vzdalena-plocha/prace-sluzebniPc-rdp.sh
Icon=krdc
Terminal=false
StartupNotify=true
'';

# =========================

# ServerPC-sync

# =========================

home.file.".local/share/applications/serverPc-sync.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=ServerPC-sync dílna
Exec=/home/gregor/.ssh/vzdalena-plocha/prace-serverPc-sync-rdp.sh
Icon=krdc
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
