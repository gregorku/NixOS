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
  <!-- VPN sítě           -->
  <!-- ========================= -->

  <Menu>
    <Name>VPN</Name>
    <Directory>vpn-desktop.directory</Directory>

    <Include>
      <Filename>vpn-pracovni.desktop</Filename>
      <Filename>vpn-pracovni-odpojeni.desktop</Filename>
      <Filename>vpn-wg1-netcup.desktop</Filename>
      <Filename>vpn-wg1-netcup-odpojeni.desktop</Filename>
    </Include>

    <Layout>
      <Filename>vpn-pracovni.desktop</Filename>
      <Filename>vpn-pracovni-odpojeni.desktop</Filename>
      <Filename>vpn-wg1-netcup.desktop</Filename>
      <Filename>vpn-wg1-netcup-odpojeni.desktop</Filename>
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

        <Filename>ssh-netcup-servervps.desktop</Filename>
        <Filename>ssh-netcup-servervps-root.desktop</Filename>
        <Filename>ssh-netcup-test-servervps.desktop</Filename>
        <Filename>ssh-netcup-test-servervps-root.desktop</Filename>
      </Include>

      <Layout>
        <Filename>ssh-netcup-servervps.desktop</Filename>
        <Filename>ssh-netcup-servervps-root.desktop</Filename>
        <Filename>ssh-netcup-test-servervps.desktop</Filename>
        <Filename>ssh-netcup-test-servervps-root.desktop</Filename>
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
  <!-- HDD                       -->
  <!-- ========================= -->

  <Menu>
    <Name>HDD</Name>
    <Directory>hdd.directory</Directory>

    <!-- ========================= -->
    <!-- Servery Pc HDD            -->
    <!-- ========================= -->

    <Menu>
      <Name>Servery Pc HDD</Name>
      <Directory>hdd-serveryPc.directory</Directory>

      <Include>
        <Filename>hdd-server-domaPc.desktop</Filename>
        <Filename>hdd-server-domaPc-root.desktop</Filename>
        <Filename>hdd-server-pracePc.desktop</Filename>
        <Filename>hdd-server-pracePc-root.desktop</Filename>        
        <Filename>hdd-virt-pracePc.desktop</Filename>
        <Filename>hdd-virt-pracePc-root.desktop</Filename>
        <Filename>hdd-test-pracePc.desktop</Filename>
        <Filename>hdd-test-pracePc-root.desktop</Filename>
        <Filename>hdd-pracovni-pracePc.desktop</Filename>
        <Filename>hdd-pracovni-pracePc-root.desktop</Filename>
        <Filename>hdd-raspberry-5b-prace.desktop</Filename>
        <Filename>hdd-raspberry-5b-prace-root.desktop</Filename>        
        <Filename>hdd-lenovo.desktop</Filename>
        <Filename>hdd-nikola.desktop</Filename>
        <Filename>hdd-nikola-root.desktop</Filename>
        <Filename>hdd-raspberry-3b-nikola.desktop</Filename>
        <Filename>hdd-raspberry-3b-nikola-root.desktop</Filename>
        <Filename>hdd-virtpc-webmin.desktop</Filename>
      </Include>

      <Layout>
        <Filename>hdd-server-domaPc.desktop</Filename>
        <Filename>hdd-server-domaPc-root.desktop</Filename>
        <Filename>hdd-server-pracePc.desktop</Filename>
        <Filename>hdd-server-pracePc-root.desktop</Filename>        
        <Filename>hdd-virt-pracePc.desktop</Filename>
        <Filename>hdd-virt-pracePc-root.desktop</Filename>
        <Filename>hdd-test-pracePc.desktop</Filename>
        <Filename>hdd-test-pracePc-root.desktop</Filename>
        <Filename>hdd-pracovni-pracePc.desktop</Filename>
        <Filename>hdd-pracovni-pracePc-root.desktop</Filename>
        <Filename>hdd-raspberry-5b-prace.desktop</Filename>
        <Filename>hdd-raspberry-5b-prace-root.desktop</Filename>        
        <Filename>hdd-lenovo.desktop</Filename>
        <Filename>hdd-nikola.desktop</Filename>
        <Filename>hdd-nikola-root.desktop</Filename>
        <Filename>hdd-raspberry-3b-nikola.desktop</Filename>
        <Filename>hdd-raspberry-3b-nikola-root.desktop</Filename>
        <Filename>hdd-virtpc-webmin.desktop</Filename>
      </Layout>
    </Menu>

    <!-- ========================= -->
    <!-- VPS HDD                   -->
    <!-- ========================= -->

    <Menu>
      <Name>VPS HDD</Name>
      <Directory>hdd-vps.directory</Directory>

      <Include>

        <Filename>hdd-netcup-servervps.desktop</Filename>
        <Filename>hdd-netcup-servervps-root.desktop</Filename>
        <Filename>hdd-netcup-lxc-aplikace.desktop</Filename>
        <Filename>hdd-alwyzon-serverpc.desktop</Filename>
      </Include>

      <Layout>
        <Filename>hdd-netcup-servervps.desktop</Filename>
        <Filename>hdd-netcup-servervps-root.desktop</Filename>
        <Filename>hdd-netcup-lxc-aplikace.desktop</Filename>
        <Filename>hdd-alwyzon-serverpc.desktop</Filename>
      </Layout>
    </Menu>

    <!-- ========================= -->
    <!-- Pořadí podmenu SSH        -->
    <!-- ========================= -->

    <Layout>
      <Menuname>Servery Pc HDD</Menuname>
      <Menuname>VPS HDD</Menuname>
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
    <Menuname>VPN</Menuname>
    <Menuname>SSH</Menuname>
    <Menuname>HDD</Menuname>    
    <Menuname>Kamery</Menuname>
  </Layout>

</Menu>

'';
}
