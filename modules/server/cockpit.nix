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

  # IPv4 only
  systemd.sockets.cockpit.socketConfig = {
    ListenStream = lib.mkForce [ "0.0.0.0:9090" ];
  };

  security.polkit.enable = true;

  ############################################################
  # 📊 PCP – instalace + služby ručně
  ############################################################
  environment.systemPackages = with pkgs; [
    pcp
  ];

  # PCP daemon (sběr metrik)
  systemd.services.pmcd = {
    description = "Performance Co-Pilot Collector Daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.pcp}/bin/pmcd -f";
      Restart = "always";
    };
  };

  # Logger (historie metrik)
  systemd.services.pmlogger = {
    description = "Performance Co-Pilot Logger";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.pcp}/bin/pmlogger -f /var/log/pcp/pmlogger/$(hostname)";
      Restart = "always";
    };
  };

  ############################################################
  # 🧹 Cleanup (rotace + retence)
  ############################################################
  systemd.services.pcp-cleanup = {
    description = "PCP archive cleanup";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.pcp}/bin/pmlogger_daily";
    };
  };

  systemd.timers.pcp-cleanup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}