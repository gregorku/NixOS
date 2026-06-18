{ ... }:

{
  # =========================
  # Kategorie SSH
  # =========================

  home.file.".local/share/desktop-directories/ssh.directory".text = ''
    [Desktop Entry]
    Type=Directory
    Name=SSH
    Icon=utilities-terminal
  '';

  home.file.".local/share/desktop-directories/ssh-servery.directory".text = ''
    [Desktop Entry]
    Type=Directory
    Name=Servery
    Icon=utilities-terminal
  '';

  home.file.".local/share/desktop-directories/ssh-routery.directory".text = ''
    [Desktop Entry]
    Type=Directory
    Name=Routery
    Icon=utilities-terminal
  '';

  home.file.".local/share/desktop-directories/ssh-pracovni.directory".text = ''
    [Desktop Entry]
    Type=Directory
    Name=Pracovní
    Icon=utilities-terminal
  '';

  # =========================
  # Servery
  # =========================

  home.file.".local/share/applications/ssh-lenovo.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Lenovo
    Exec=/home/gregor/.ssh/ssh-lenovo.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-netcup-serverpc.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Netcup ServerPC
    Exec=/home/gregor/.ssh/ssh-netcup-serverpc.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-netcup-test-serverpc.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Netcup Test ServerPC
    Exec=/home/gregor/.ssh/ssh-netcup-test-serverpc.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-nikola.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Nikola
    Exec=/home/gregor/.ssh/ssh-nikola.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-raspberry-3b-nikola.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Raspberry 3B Nikola
    Exec=/home/gregor/.ssh/ssh-raspberry-3b-nikola.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-server-doma.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Server Doma
    Exec=/home/gregor/.ssh/ssh-server-doma.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-testpc.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=TestPC
    Exec=/home/gregor/.ssh/ssh-testpc.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-virtpc-prace.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=VirtPC Práce
    Exec=/home/gregor/.ssh/ssh-virtpc-prace.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-virtpc-webmin.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=VirtPC Webmin
    Exec=/home/gregor/.ssh/ssh-virtpc-webmin.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-alwyzon-serverpc.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Alwyzon ServerPC
    Exec=/home/gregor/.ssh/ssh-alwyzon-serverpc.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-netcup-lxc-aplikace.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Netcup LXC Aplikace
    Exec=/home/gregor/.ssh/ssh-netcup-lxc-aplikace.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  # =========================
  # Routery
  # =========================

  home.file.".local/share/applications/ssh-mikrotik-test.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Mikrotik Test
    Exec=/home/gregor/.ssh/ssh-mikrotik-test.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-cisco-jirkov.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Cisco Jirkov
    Exec=/home/gregor/.ssh/ssh-cisco-jirkov.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  # =========================
  # Pracovní
  # =========================

  home.file.".local/share/applications/ssh-pracovniPc-prace.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Pracovní PC
    Exec=/home/gregor/.ssh/ssh-pracovniPc-prace.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-pracovniPc-prace-root.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Pracovní PC Root
    Exec=/home/gregor/.ssh/ssh-pracovniPc-prace-root.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-serverPc-prace.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=ServerPC Práce Root
    Exec=/home/gregor/.ssh/ssh-serverPc-prace.sh
    Icon=utilities-terminal
    Terminal=false
    StartupNotify=true
  '';

  home.file.".local/share/applications/ssh-raspberry-5b-prace.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Raspberry 5B Práce
    Exec=/home/gregor/.ssh/ssh-raspberry-5b-prace.sh
    Icon=utilities-terminal
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
        <Name>SSH</Name>
        <Directory>ssh.directory</Directory>

        <Menu>
          <Name>Servery</Name>
          <Directory>ssh-servery.directory</Directory>
          <Include>
            <Filename>ssh-lenovo.desktop</Filename>
            <Filename>ssh-netcup-serverpc.desktop</Filename>
            <Filename>ssh-netcup-test-serverpc.desktop</Filename>
            <Filename>ssh-nikola.desktop</Filename>
            <Filename>ssh-raspberry-3b-nikola.desktop</Filename>
            <Filename>ssh-server-doma.desktop</Filename>
            <Filename>ssh-testpc.desktop</Filename>
            <Filename>ssh-virtpc-prace.desktop</Filename>
            <Filename>ssh-virtpc-webmin.desktop</Filename>
            <Filename>ssh-alwyzon-serverpc.desktop</Filename>
            <Filename>ssh-netcup-lxc-aplikace.desktop</Filename>
          </Include>
        </Menu>

        <Menu>
          <Name>Routery</Name>
          <Directory>ssh-routery.directory</Directory>
          <Include>
            <Filename>ssh-mikrotik-test.desktop</Filename>
            <Filename>ssh-cisco-jirkov.desktop</Filename>
          </Include>
        </Menu>

        <Menu>
          <Name>Pracovní</Name>
          <Directory>ssh-pracovni.directory</Directory>
          <Include>
            <Filename>ssh-pracovniPc-prace.desktop</Filename>
            <Filename>ssh-pracovniPc-prace-root.desktop</Filename>
            <Filename>ssh-serverPc-prace.desktop</Filename>
            <Filename>ssh-raspberry-5b-prace.desktop</Filename>
          </Include>
        </Menu>

      </Menu>

      <Layout>
        <Menuname>SSH</Menuname>
      </Layout>

    </Menu>
  '';
}