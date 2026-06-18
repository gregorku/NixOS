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
  # Pracovní PC
  # =========================

  home.file.".local/share/applications/pracovniPc.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Pracovní PC
    Comment=RDP připojení na pracovní počítač
    Exec=/home/gregor/.ssh/pracePc-rdp.sh
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
    Name=Služební PC
    Exec=/home/gregor/.ssh/sluzebniPc-rdp.sh
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
    Name=ServerPC-sync
    Exec=/home/gregor/.ssh/serverPc-sync.sh
    Icon=krdc
    Terminal=false
    StartupNotify=true
  '';

  # =========================
  # Práce PC
  # =========================

  home.file.".local/share/applications/pracePc.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Práce PC
    Exec=/home/gregor/.ssh/pracePc.sh
    Icon=krdc
    Terminal=false
    StartupNotify=true
  '';

  # =========================
  # KDE Menu
  # =========================

  home.file.".config/menus/applications-kmenuedit.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
      "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">

    <Menu>
      <Name>Applications</Name>

      <Menu>
        <Name>Vzdálená plocha</Name>
        <Directory>remote-desktop.directory</Directory>

        <Include>
          <Filename>pracovniPc.desktop</Filename>
          <Filename>sluzebniPc.desktop</Filename>
          <Filename>serverPc-sync.desktop</Filename>
          <Filename>pracePc.desktop</Filename>
        </Include>

        <Layout>
          <Filename>pracovniPc.desktop</Filename>
          <Filename>sluzebniPc.desktop</Filename>
          <Filename>serverPc-sync.desktop</Filename>
          <Filename>pracePc.desktop</Filename>
        </Layout>
      </Menu>

      <Layout>
        <Menuname>Vzdálená plocha</Menuname>
      </Layout>

    </Menu>
  '';
}