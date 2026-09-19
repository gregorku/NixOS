{
  config,
  pkgs,
  lib,
  ...
}: let
  ##################################################
  # WireGuard peers
  #
  # Jméno klienta je nyní součástí dat.
  # Z tohoto seznamu se následně generuje konfigurace
  # pro jednotlivá WireGuard rozhraní.
  ##################################################
  peers = {
    doma = {
      name = "Mikrotik doma";
      wg1 = {
        publicKey = "ZRRN9IVqc8atE1Cby4k00YKe0bd74N7/TkKZkIybKyk=";
        allowedIP = "10.100.100.100/32";
      };
      wg2 = {
        publicKey = "F4BOM0b5wukasvyv63EG6p61ZNMuwySSp09+j06iyHQ=";
        allowedIP = "10.110.100.100/32";
      };
      wg3 = {
        publicKey = "YHrYI2NdO8whuGxkEel1AixrvMVDz/KuMqmzI/v73QA=";
        allowedIP = "10.120.100.100/32";
      };
    };

    jirkov = {
      name = "Mikrotik jirkov";
      wg1 = {
        publicKey = "vy/pvrKC55vhw1HDNrP/TnG3Y5mdaUcUsTOdJhRylWA=";
        allowedIP = "10.100.100.220/32";
      };
      wg2 = {
        publicKey = "OEnlmHsnNk+oIpvGOf8nF48r05G7PsCIjvMUJ8Cxd1Y=";
        allowedIP = "10.110.100.220/32";
      };
      wg3 = {
        publicKey = "HJmLfobWN7ZEjPt5PgeId0IUZBS+5odYCZATmR7whw4=";
        allowedIP = "10.120.100.220/32";
      };
    };

    bratrmach = {
      name = "Mikrotik bratrmach";
      wg1 = {
        publicKey = "bozqiwT51C/Zhls/IBlKvHzYYQbAdUDJhB4pNoKdzEQ=";
        allowedIP = "10.100.100.10/32";
      };
      wg2 = {
        publicKey = "781kl7aR4tKfycU9hU30pzmD5sDpHgjpQPnWODPpWUk=";
        allowedIP = "10.110.100.10/32";
      };
      wg3 = {
        publicKey = "LK5kXiC0Ze7OiSjH+jgD+tcCfiAdPg6OqzMG34Lxm2A=";
        allowedIP = "10.120.100.10/32";
      };
    };

    klinovec = {
      name = "Mikrotik klinovec";
      wg1 = {
        publicKey = "h0MYWHaQ0tZLv6MSJEb+QLX0MgJvJHs6wT0vDzqY2Qw=";
        allowedIP = "10.100.100.210/32";
      };
      wg2 = {
        publicKey = "BJrynnxoI/PkErV2IGLUw3YuolmJMOxKnP5Kx1y/8n4=";
        allowedIP = "10.110.100.210/32";
      };
      wg3 = {
        publicKey = "s9SmdTiHfIC17SApFbii+IHoZGi/tYk7tNVD0mrE6WA=";
        allowedIP = "10.120.100.210/32";
      };
    };

    prace = {
      name = "Mikrotik prace";
      wg1 = {
        publicKey = "67t2MwYpEsjDZUYs2cwmeWImcJE+v/r+z8MT47jJEDU=";
        allowedIP = "10.100.100.12/32";
      };
      wg2 = {
        publicKey = "RQ0tpTCNb6XJLBAb/KeTe66+xGAWMGoro6n3JIDvq0w=";
        allowedIP = "10.110.100.12/32";
      };
      wg3 = {
        publicKey = "G6Pf0bPmFXY9cQOoT1MERNY58ZisX9sL9wkFLd8DGh8=";
        allowedIP = "10.120.100.12/32";
      };
    };

    test = {
      name = "Mikrotik test";
      wg1 = {
        publicKey = "4gCXT1X3S25rmRBAqSbC9fQLFCARJHfSqwUhlOyIKgw=";
        allowedIP = "10.100.100.5/32";
      };
      wg2 = {
        publicKey = "IAPBFkq+wBhbUzfXiSa+yMyXvntiVXOt1r/zLB996Sk=";
        allowedIP = "10.110.100.5/32";
      };
      wg3 = {
        publicKey = "UDL0tHuDl0gEoUa6G/zM31fgjiIG6CdGnsVPqmo18V8=";
        allowedIP = "10.120.100.5/32";
      };
    };

    udlice = {
      name = "Mikrotik udlice";
      wg1 = {
        publicKey = "f9JErcFF6j5DRZnSmFtr89lWOiSBSvrXIdFB29Nw3Fs=";
        allowedIP = "10.100.100.200/32";
      };
      wg2 = {
        publicKey = "uPV1wEMUbTGtPD2nYFpemg8paucEOGIOhMnHGJr4WSw=";
        allowedIP = "10.110.100.200/32";
      };
      wg3 = {
        publicKey = "2JhsoHf/VXltiU6NJFhU3Rc0bt2hHJy2wJOcB8RZ11c=";
        allowedIP = "10.120.100.200/32";
      };
    };

    mujmobil = {
      name = "Mobil mujmobil";
      wg1 = {
        publicKey = "J6EufZFy3mb7wyCV6vP/XvrEEZLd4THYYzcKiB+THzo=";
        allowedIP = "10.100.100.152/32";
      };
    };

    ntblenovo = {
      name = "Notebook ntblenovo";
      wg1 = {
        publicKey = "hDKHmFQ0SyFgOzAoZQb4ywb0PwMyJAlqwXyuC3+oATU=";
        allowedIP = "10.100.100.150/32";
      };
    };

    ntbpracovni = {
      name = "Notebook ntbpracovni";
      wg1 = {
        publicKey = "aoNFdXvTciXud3FlzJZB0uy1ZPlmK3CgKiwFcyb4lX8=";
        allowedIP = "10.100.100.151/32";
      };
    };
  };

  ##################################################
  # Převod našeho seznamu do formátu NixOS
  ##################################################

  mkPeer = peer: {
    publicKey = peer.publicKey;
    allowedIPs = [peer.allowedIP];
  };

  peersForInterface = interface:
    lib.mapAttrsToList
    (
      _: peer:
        mkPeer peer.${interface}
    )
    (
      lib.filterAttrs
      (_: _: _.${interface} or null != null)
      peers
    );
in {
  ##################################################
  # AGENIX secrets
  ##################################################

  age.secrets.wg1_serverVPS-private.file =
    ../../VPSsecret/wireguard/wg1_serverVPS-private.age;

  age.secrets.wg2_serverVPS-private.file =
    ../../VPSsecret/wireguard/wg2_serverVPS-private.age;

  age.secrets.wg3_serverVPS-private.file =
    ../../VPSsecret/wireguard/wg3_serverVPS-private.age;

  ##################################################
  # WireGuard
  ##################################################

  networking.wireguard.interfaces = {
    ##################################################
    # WG1
    ##################################################

    wg1 = {
      ips = ["10.100.100.1/24"];
      listenPort = 53820;
      privateKeyFile = config.age.secrets.wg1_serverVPS-private.path;

      peers = peersForInterface "wg1";
    };

    ##################################################
    # WG2
    ##################################################

    wg2 = {
      ips = ["10.110.100.1/24"];
      listenPort = 53821;
      privateKeyFile = config.age.secrets.wg2_serverVPS-private.path;

      peers = peersForInterface "wg2";
    };

    ##################################################
    # WG3
    ##################################################

    wg3 = {
      ips = ["10.120.100.1/24"];
      listenPort = 53822;
      privateKeyFile = config.age.secrets.wg3_serverVPS-private.path;

      peers = peersForInterface "wg3";
    };
  };
}
