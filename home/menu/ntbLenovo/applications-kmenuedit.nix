{ ... }:

{
home.file.".config/menus/applications-kmenuedit.menu".text = ''



<Menu>
  <Name>Applications</Name>

  <!-- ========================= -->
  <!-- Vzdálená plocha            -->
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
  <!-- SSH                        -->
  <!-- ========================= -->

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

  <!-- ========================= -->
  <!-- Pořadí v menu              -->
  <!-- ========================= -->

  <Layout>
    <Menuname>Vzdálená plocha</Menuname>
    <Menuname>SSH</Menuname>
  </Layout>

</Menu>

'';
}