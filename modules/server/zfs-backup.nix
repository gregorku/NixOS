{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zfs
  ];

  # jednoduchý cron backup (můžeš nahradit syncoid/sanoid později)
  systemd.services.zfs-backup = {
    script = ''
      zfs snapshot zfs-pool-incus/incus@auto-$(date +%Y-%m-%d-%H%M)

      # příklad: lokální backup
      zfs send -R zfs-pool-incus/incus@auto-$(date +%Y-%m-%d-%H%M) \
        | zfs receive -F zfs-pool-incus/backups/incus
    '';
    serviceConfig.Type = "oneshot";
  };

  systemd.timers.zfs-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}