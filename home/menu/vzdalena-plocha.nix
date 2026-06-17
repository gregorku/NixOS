{ pkgs, ... }:

{
  xdg.desktopEntries.pracovniPc = {
    name = "Pracovní PC";
    exec = "/home/gregor/.ssh/pracePc-rdp.sh";
    icon = "krdc";
    terminal = false;
    categories = [ "RemoteAccess" ];
  };

  xdg.desktopEntries.sluzebniPc = {
    name = "Služební PC";
    exec = "/home/gregor/.ssh/sluzebniPc-rdp.sh";
    icon = "krdc";
    terminal = false;
    categories = [ "RemoteAccess" ];
  };

  xdg.desktopEntries.serverPcSync = {
    name = "ServerPC-sync";
    exec = "/home/gregor/.ssh/serverPc-sync.sh";
    icon = "krdc";
    terminal = false;
    categories = [ "RemoteAccess" ];
  };

  xdg.desktopEntries.pracePc = {
    name = "Práce PC";
    exec = "/home/gregor/.ssh/pracePc.sh";
    icon = "krdc";
    terminal = false;
    categories = [ "RemoteAccess" ];
  };
}