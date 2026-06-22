{ ... }:

{

# =========================

# Kategorie VPN

# =========================

home.file.".local/share/desktop-directories/vpn-desktop.directory".text = ''
[Desktop Entry]
Type=Directory
Name=VPN
Icon=network-vpn
'';

# =========================

# VPN Pracovní

# =========================

home.file.".local/share/applications/vpn-pracovni.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=VPN Pracovní
Comment=VPN pracovní síť
Exec=/home/gregor/.ssh/vpn/vpn-pracovni.sh
Icon=network-vpn
Terminal=false
StartupNotify=true
'';

home.file.".local/share/applications/vpn-pracovni-odpojeni.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=VPN Pracovní odpojení
Comment=VPN pracovní síť
Exec=/home/gregor/.ssh/vpn/vpn-pracovni-odpojeni.sh
Icon=network-vpn
Terminal=false
StartupNotify=true
'';

# =========================

# VPN wg1-Netcup

# =========================

home.file.".local/share/applications/vpn-wg1-netcup.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=VPN wg1 Netcup
Exec=/home/gregor/.ssh/vpn/vpn-wg1-netcup.sh
Icon=network-vpn
Terminal=false
StartupNotify=true
'';

home.file.".local/share/applications/vpn-wg1-netcup-odpojeni.desktop".text = ''
[Desktop Entry]
Version=1.0
Type=Application
Name=VPN wg1 Netcup odpojení
Exec=/home/gregor/.ssh/vpn/vpn-wg1-netcup-odpojeni.sh
Icon=network-vpn
Terminal=false
StartupNotify=true
'';
}
