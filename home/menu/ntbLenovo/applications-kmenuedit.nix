{ ... }:

{
home.file.".config/menus/applications-kmenuedit.menu".text = ''

<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
  "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">

<Menu>
  <Name>Applications</Name>

  <!-- ========================= -->
  <!-- Gocryptfs data           -->
  <!-- ========================= -->

  <Menu>
    <Name>Gocryptfs</Name>
    <Directory>gocryptfs-desktop.directory</Directory>

    <Include>
      <Filename>gocryptfs-dokumenty.desktop</Filename>
      <Filename>gocryptfs-dokumenty-odpojeni.desktop</Filename>
      <Filename>gocryptfs-data.desktop</Filename>
      <Filename>gocryptfs-data-odpojeni.desktop</Filename>
      <Filename>gocryptfs-zalohantb.desktop</Filename>
      <Filename>gocryptfs-zalohantb-odpojeni.desktop</Filename>
    </Include>

    <Layout>
      <Filename>gocryptfs-dokumenty.desktop</Filename>
      <Filename>gocryptfs-dokumenty-odpojeni.desktop</Filename>
      <Filename>gocryptfs-data.desktop</Filename>
      <Filename>gocryptfs-data-odpojeni.desktop</Filename>
      <Filename>gocryptfs-zalohantb.desktop</Filename>
      <Filename>gocryptfs-zalohantb-odpojeni.desktop</Filename>
    </Layout>
  </Menu>

  <!-- ========================= -->
  <!-- Vzdálená plocha           -->
  <!-- ========================= -->

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

  <!-- ========================= -->
  <!-- SSH                       -->
  <!-- ========================= -->

  <Menu>
    <Name>SSH</Name>
    <Directory>ssh.directory</Directory>

    <!-- ========================= -->
    <!-- Servery Pc                -->
    <!-- ========================= -->

    <Menu>
      <Name>Servery Pc</Name>
      <Directory>ssh-serveryPc.directory</Directory>

      <Include>
        <Filename>ssh-server-doma.desktop</Filename>
        <Filename>ssh-server-doma-root.desktop</Filename>
        <Filename>ssh-serverPc-prace.desktop</Filename>
        <Filename>ssh-serverPc-prace-root.desktop</Filename>        
        <Filename>ssh-virtPc-prace.desktop</Filename>
        <Filename>ssh-virtPc-prace-root.desktop</Filename>
        <Filename>ssh-testPc.desktop</Filename>
        <Filename>ssh-testPc-root.desktop</Filename>
        <Filename>ssh-pracovniPc-prace.desktop</Filename>
        <Filename>ssh-pracovniPc-prace-root.desktop</Filename>
        <Filename>ssh-raspberry-5b-prace.desktop</Filename>
        <Filename>ssh-raspberry-5b-prace-root.desktop</Filename>        
        <Filename>ssh-lenovo.desktop</Filename>
        <Filename>ssh-nikola.desktop</Filename>
        <Filename>ssh-nikola-root.desktop</Filename>
        <Filename>ssh-raspberry-3b-nikola.desktop</Filename>
        <Filename>ssh-raspberry-3b-nikola-root.desktop</Filename>
        <Filename>ssh-virtpc-webmin.desktop</Filename>
      </Include>

      <Layout>
        <Filename>ssh-server-doma.desktop</Filename>
        <Filename>ssh-server-doma-root.desktop</Filename>
        <Filename>ssh-serverPc-prace.desktop</Filename>
        <Filename>ssh-serverPc-prace-root.desktop</Filename>
        <Filename>ssh-virtPc-prace.desktop</Filename>
        <Filename>ssh-virtPc-prace-root.desktop</Filename>
        <Filename>ssh-testPc.desktop</Filename>
        <Filename>ssh-testPc-root.desktop</Filename>
        <Filename>ssh-pracovniPc-prace.desktop</Filename>
        <Filename>ssh-pracovniPc-prace-root.desktop</Filename>
        <Filename>ssh-raspberry-5b-prace.desktop</Filename>
        <Filename>ssh-raspberry-5b-prace-root.desktop</Filename>         
        <Filename>ssh-lenovo.desktop</Filename>
        <Filename>ssh-nikola.desktop</Filename>
        <Filename>ssh-nikola-root.desktop</Filename>
        <Filename>ssh-raspberry-3b-nikola.desktop</Filename>
        <Filename>ssh-raspberry-3b-nikola-root.desktop</Filename>
        <Filename>ssh-virtpc-webmin.desktop</Filename>
      </Layout>
    </Menu>

    <!-- ========================= -->
    <!-- VPS                       -->
    <!-- ========================= -->

    <Menu>
      <Name>VPS</Name>
      <Directory>ssh-vps.directory</Directory>

      <Include>

        <Filename>ssh-netcup-serverpc.desktop</Filename>
        <Filename>ssh-netcup-test-serverpc.desktop</Filename>
        <Filename>ssh-netcup-lxc-aplikace.desktop</Filename>
        <Filename>ssh-alwyzon-serverpc.desktop</Filename>
      </Include>

      <Layout>
        <Filename>ssh-netcup-serverpc.desktop</Filename>
        <Filename>ssh-netcup-test-serverpc.desktop</Filename>
        <Filename>ssh-netcup-lxc-aplikace.desktop</Filename>
        <Filename>ssh-alwyzon-serverpc.desktop</Filename>
      </Layout>
    </Menu>

    <!-- ========================= -->
    <!-- Routery Switche           -->
    <!-- ========================= -->

    <Menu>
      <Name>Routery Switche</Name>
      <Directory>ssh-routery.directory</Directory>

      <Include>
        <Filename>ssh-mikrotik-test.desktop</Filename>
        <Filename>ssh-cisco-jirkov.desktop</Filename>
      </Include>

      <Layout>
        <Filename>ssh-mikrotik-test.desktop</Filename>
        <Filename>ssh-cisco-jirkov.desktop</Filename>
      </Layout>
    </Menu>

    <!-- ========================= -->
    <!-- Pořadí podmenu SSH        -->
    <!-- ========================= -->

    <Layout>
      <Menuname>Servery Pc</Menuname>
      <Menuname>VPS</Menuname>
      <Menuname>Routery Switche</Menuname>
    </Layout>

  </Menu>

  <!-- ========================= -->
  <!-- Kamery           -->
  <!-- ========================= -->

  <Menu>
    <Name>Kamery</Name>
    <Directory>kamery-desktop.directory</Directory>

    <Include>
      <Filename>kamera-loznice.desktop</Filename>
      <Filename>kamera-obyvak.desktop</Filename>
      <Filename>kamera-3dprint.desktop</Filename>
    </Include>

    <Layout>
      <Filename>kamera-loznice.desktop</Filename>
      <Filename>kamera-obyvak.desktop</Filename>
      <Filename>kamera-3dprint.desktop</Filename>
    </Layout>
  </Menu>

  <!-- ========================= -->
  <!-- Pořadí hlavního menu      -->
  <!-- ========================= -->

  <Layout>
    <Menuname>Gocryptfs</Menuname>
    <Menuname>Vzdálená plocha</Menuname>
    <Menuname>SSH</Menuname>
    <Menuname>Kamery</Menuname>
  </Layout>

</Menu>

'';
}
