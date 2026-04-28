{ config, pkgs, lib, ... }:

{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;

    settings = {
      WebService = {
        AllowUnencrypted = true;
        Origins = lib.mkForce "*";
      };
    };
  };

  # Vynucení poslouchání pouze na IPv4
  systemd.sockets.cockpit.socketConfig = {
    ListenStream = lib.mkForce [ "0.0.0.0:9090" ];
  };

  security.polkit.enable = true;

  ############################################################
  # 📊 Performance Co-Pilot (PCP) – historie metrik
  ############################################################
  services.pcp = {
    enable = true;

    # Zapnutí archivace (nutné pro historické grafy v Cockpitu)
    archive = {
      enable = true;

      # Interval sběru metrik
      # 10s = dobrý kompromis mezi přesností a velikostí dat
      interval = "10s";
    };
  };

  ############################################################
  # 🧹 Retence a rotace logů PCP (aby ti to nesežralo disk)
  ############################################################
  systemd.services.pcp-archive-cleanup = {
    description = "PCP archive cleanup";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.pcp}/bin/pmlogger_daily -K -E
      '';
    };
  };

  systemd.timers.pcp-archive-cleanup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  ############################################################
  # 📦 Užitečné nástroje pro debug / ruční kontrolu
  ############################################################
  environment.systemPackages = with pkgs; [
    pcp   # pminfo, pmstat, pmrep...
  ];
}
