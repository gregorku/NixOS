{
  config,
  pkgs,
  lib,
  ...
}:

{
  ##################################################
  # AGENIX secrets
  ##################################################
  age.secrets.wg1_serverVPS-private.file = ../../VPSsecret/wireguard/wg1_serverVPS-private.age;

  age.secrets.wg2_serverVPS-private.file = ../../VPSsecret/wireguard/wg2_serverVPS-private.age;

  age.secrets.wg3_serverVPS-private.file = ../../VPSsecret/wireguard/wg3_serverVPS-private.age;

  ##################################################
  # WireGuard
  ##################################################
  networking.wireguard.interfaces = {

    wg1 = {
      ips = [ "10.100.100.1/24" ];
      listenPort = 53820;
      privateKeyFile = config.age.secrets.wg1_serverVPS-private.path;

      peers = [
        {
          # Mikrotik doma wg1
          publicKey = "ZRRN9IVqc8atE1Cby4k00YKe0bd74N7/TkKZkIybKyk=";
          allowedIPs = [ "10.100.100.100/32" ];
        }
        {
          # Mikrotik jirkov wg1
          publicKey = "vy/pvrKC55vhw1HDNrP/TnG3Y5mdaUcUsTOdJhRylWA=";
          allowedIPs = [ "10.100.100.220/32" ];
        }
        {
          # Mikrotik bratrmach wg1
          publicKey = "bozqiwT51C/Zhls/IBlKvHzYYQbAdUDJhB4pNoKdzEQ=";
          allowedIPs = [ "10.100.100.10/32" ];
        }
        {
          # Mikrotik klinovec wg1
          publicKey = "h0MYWHaQ0tZLv6MSJEb+QLX0MgJvJHs6wT0vDzqY2Qw=";
          allowedIPs = [ "10.100.100.210/32" ];
        }
        {
          # Mikrotik prace wg1
          publicKey = "67t2MwYpEsjDZUYs2cwmeWImcJE+v/r+z8MT47jJEDU=";
          allowedIPs = [ "10.100.100.12/32" ];
        }
        {
          # Mikrotik test wg1
          publicKey = "4gCXT1X3S25rmRBAqSbC9fQLFCARJHfSqwUhlOyIKgw=";
          allowedIPs = [ "10.100.100.5/32" ];
        }
        {
          # Mikrotik udlice wg1
          publicKey = "f9JErcFF6j5DRZnSmFtr89lWOiSBSvrXIdFB29Nw3Fs=";
          allowedIPs = [ "10.100.100.200/32" ];
        }
        {
          # Mobil mujmobil wg1
          publicKey = "J6EufZFy3mb7wyCV6vP/XvrEEZLd4THYYzcKiB+THzo=";
          allowedIPs = [ "10.100.100.152/32" ];
        }
        {
          # Notebook ntblenovo wg1
          publicKey = "hDKHmFQ0SyFgOzAoZQb4ywb0PwMyJAlqwXyuC3+oATU=";
          allowedIPs = [ "10.100.100.150/32" ];
        }
        {
          # Notebook ntbpracovni wg1
          publicKey = "ZwQudYCEjias6xdptTSjwtfpemhYVdmGOvBvnQyoeRo=";
          allowedIPs = [ "10.100.100.151/32" ];
        }
      ];
    };

    wg2 = {
      ips = [ "10.110.100.1/24" ];
      listenPort = 53821;
      privateKeyFile = config.age.secrets.wg2_serverVPS-private.path;

      peers = [
        {
          # Mikrotik doma wg2
          publicKey = "F4BOM0b5wukasvyv63EG6p61ZNMuwySSp09+j06iyHQ=";
          allowedIPs = [ "10.110.100.100/32" ];
        }
        {
          # Mikrotik jirkov wg2
          publicKey = "OEnlmHsnNk+oIpvGOf8nF48r05G7PsCIjvMUJ8Cxd1Y=";
          allowedIPs = [ "10.110.100.220/32" ];
        }
        {
          # Mikrotik bratrmach wg2
          publicKey = "781kl7aR4tKfycU9hU30pzmD5sDpHgjpQPnWODPpWUk=";
          allowedIPs = [ "10.110.100.10/32" ];
        }
        {
          # Mikrotik klinovec wg2
          publicKey = "BJrynnxoI/PkErV2IGLUw3YuolmJMOxKnP5Kx1y/8n4=";
          allowedIPs = [ "10.110.100.210/32" ];
        }
        {
          # Mikrotik prace wg2
          publicKey = "RQ0tpTCNb6XJLBAb/KeTe66+xGAWMGoro6n3JIDvq0w=";
          allowedIPs = [ "10.110.100.12/32" ];
        }
        {
          # Mikrotik test wg2
          publicKey = "IAPBFkq+wBhbUzfXiSa+yMyXvntiVXOt1r/zLB996Sk=";
          allowedIPs = [ "10.110.100.5/32" ];
        }
        {
          # Mikrotik udlice wg2
          publicKey = "uPV1wEMUbTGtPD2nYFpemg8paucEOGIOhMnHGJr4WSw=";
          allowedIPs = [ "10.110.100.200/32" ];
        }
      ];
    };

    wg3 = {
      ips = [ "10.120.120.1/24" ];
      listenPort = 53832;
      privateKeyFile = config.age.secrets.wg3_serverVPS-private.path;

      peers = [
        {
          # Mikrotik doma wg3
          publicKey = "YHrYI2NdO8whuGxkEel1AixrvMVDz/KuMqmzI/v73QA=";
          allowedIPs = [ "10.120.120.100/32" ];
        }
        {
          # Mikrotik jirkov wg3
          publicKey = "HJmLfobWN7ZEjPt5PgeId0IUZBS+5odYCZATmR7whw4=";
          allowedIPs = [ "10.120.120.220/32" ];
        }
        {
          # Mikrotik bratrmach wg3
          publicKey = "LK5kXiC0Ze7OiSjH+jgD+tcCfiAdPg6OqzMG34Lxm2A=";
          allowedIPs = [ "10.120.120.10/32" ];
        }
        {
          # Mikrotik klinovec wg3
          publicKey = "s9SmdTiHfIC17SApFbii+IHoZGi/tYk7tNVD0mrE6WA=";
          allowedIPs = [ "10.120.120.210/32" ];
        }
        {
          # Mikrotik prace wg3
          publicKey = "G6Pf0bPmFXY9cQOoT1MERNY58ZisX9sL9wkFLd8DGh8=";
          allowedIPs = [ "10.120.120.12/32" ];
        }
        {
          # Mikrotik test wg3
          publicKey = "UDL0tHuDl0gEoUa6G/zM31fgjiIG6CdGnsVPqmo18V8=";
          allowedIPs = [ "10.120.120.5/32" ];
        }
        {
          # Mikrotik udlice wg3
          publicKey = "2JhsoHf/VXltiU6NJFhU3Rc0bt2hHJy2wJOcB8RZ11c=";
          allowedIPs = [ "10.120.120.200/32" ];
        }
      ];
    };

  };
}
