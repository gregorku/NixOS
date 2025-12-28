{ config, pkgs, ... }:

{
  system.stateVersion = "25.11";
  networking.hostName = "frigate-nvr";

  ## =========================
  ## SÍŤ – macvlan
  ## =========================
  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.useHostResolvConf = false;
  services.resolved.enable = true;

  systemd.network.networks."10-macvlan" = {
    matchConfig.Name = "mv-*";
    networkConfig.DHCP = "yes";
  };

  ## =========================
  ## HARDWARE AKCELERACE
  ## =========================
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
    ];
  };

  ## =========================
  ## FIX PRO KEYRING
  ## =========================
  virtualisation.containers.containersConf.settings = {
    containers = {
      keyring = false;
    };
  };

  ## =========================
  ## UŽIVATELÉ A SKUPINY
  ## =========================
  users.users.frigate.extraGroups = [ "video" "render" "dialout" ];

  ## =========================
  ## SLUŽBA FRIGATE
  ## =========================
  services.frigate = {
    enable = true;
    hostname = "frigate-nvr";

    settings = {
      # === MQTT KONFIGURACE ===
      mqtt = {
        host = "192.168.100.234";      # <--- ZDE ZADEJTE IP ADRESU MQTT BROKERA
        user = "frigate";  # <--- ZDE ZADEJTE UŽIVATELSKÉ JMÉNO
        password = "gregorek"; # <--- ZDE ZADEJTE HESLO
      };

      # Detektor (Google Coral USB)
      detectors.coral = {
        type = "edgetpu";
        device = "usb";
      };

      ## =========================
      ## === KAMERY ===
      ## =========================
      services.frigate.settings.cameras = {
        # Název kamery (používejte pouze malá písmena, čísla a podtržítka)
        kamera_loznice = { 
          ffmpeg.inputs = [
            {
              # RTSP adresa: doplňte své jméno, heslo a IP adresu kamery
                  path = "rtsp://admin:gregorku__55882@192.168.100.112:554/Streaming/channels/001/?transportmode=unicast"; 
                  roles = [ "detect" "record" ];
            }
          ];
          detect = {
            enabled = true;
            width = 1280; # Zkontrolujte rozlišení streamu
            height = 720;
          };
        };
      };
      
      record.enabled = true;
    };
  };

  ## =========================
  ## FIREWALL A SSH
  ## =========================
  networking.firewall.allowedTCPPorts = [ 5000 8554 8555 ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
  
  environment.systemPackages = with pkgs; [
    git vim nano htop libva-utils
  ];
}