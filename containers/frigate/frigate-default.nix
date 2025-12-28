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
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  ## =========================
  ## FIX PRO KEYRING
  ## =========================
  virtualisation.containers.containersConf.settings.containers.keyring = false;

  ## =========================
  ## SLUŽBA FRIGATE
  ## =========================
  services.frigate = {
    enable = true;
    hostname = "frigate-nvr";

    # Všechna nastavení musí být uvnitř tohoto bloku
    settings = {
      database.path = "/var/lib/frigate/frigate.db";
      
      mqtt = {
        host = "192.168.100.234";      # <--- DOPLŇTE IP
        user = "frigate";  # <--- DOPLŇTE JMÉNO
        password = "gregorek"; # <--- DOPLŇTE HESLO
      };

      detectors.coral = {
        type = "edgetpu";
        device = "usb";
        };
        cpu_fallback = {
        type = "cpu";
      };

      cameras = {
        kamera_loznice = { 
          detect.enabled = true;
          ffmpeg.hwaccel_args = "preset-vaapi";
          ffmpeg.inputs = [
            {
              path = "rtsp://admin:gregorku__55882@192.168.100.112:554/Streaming/channels/002/?transportmode=unicast"; 
              roles = [ "detect" "record" ];
            }
          ];
          detect = {
            enabled = true;
            width = 1280; 
            height = 720;
            fps = 5;
          };
          record.enabled = true;
        };
      };
    };
  };

  ## =========================
  ## FIREWALL A OPRÁVNĚNÍ
  ## =========================
  networking.firewall.allowedTCPPorts = [ 5000 8554 8555 ];

  users.users.frigate.extraGroups = [ "video" "render" "dialout" "users" "plugdev" ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
  
  environment.systemPackages = with pkgs; [
    git vim nano htop libva-utils libedgetpu usbutils
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/frigate 0755 frigate frigate -"
    "d /media/frigate 0755 frigate frigate -"
  ];
}