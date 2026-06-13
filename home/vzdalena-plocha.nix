{ config, pkgs, ... }:

{
  xdg.configFile."krdprc".text = ''
    [RDP]
    Enabled=true
    Port=3389
    RequireApprove=false
    # Tady krdp serveru řekneme, kde ty certifikáty přesně najde:
    CertificatePath=/home/gregor/.local/share/krdp/tls.crt
    PrivateKeyPath=/home/gregor/.local/share/krdp/tls.key
  '';
  xdg.configFile."krdprc".force = true;

  xdg.configFile."kwinrc".text = ''
    [Wayland]
    VirtualOutputs=1
  '';
  xdg.configFile."kwinrc".force = true;
}