{ config, pkgs, ... }:

{
  containers.frigate = {
    autoStart = true;
    ephemeral = true; # Při restartu se systém v kontejneru resetuje, data v bind mountech zůstanou
    config = import ./frigate-default.nix;

    # === SÍŤ ===
    # Aktivuje izolovanou síť pro kontejner a vytvoří macvlan z bridge hostitele
    privateNetwork = true;
    macvlans = [ "br0" ]; 

    # === ÚLOŽIŠTĚ A HARDWARE ===
    bindMounts = {
      # Konfigurace a databáze Frigate
      "/var/lib/frigate" = {
        hostPath = "/data/frigate";
        isReadOnly = false;
      };
      # Sdílená paměť (nutné pro předávání video streamů mezi procesy)
      "/dev/shm" = { 
        hostPath = "/dev/shm"; 
        isReadOnly = false; 
      };
      # Nahrávky a klipy
      "/media/frigate" = {
        hostPath = "/video";
        isReadOnly = false;
      };
      # Přístup ke Google Coral (USB sběrnice)
      "/dev/bus/usb" = {
        hostPath = "/dev/bus/usb";
        isReadOnly = false;
      };
      # Přístup ke GPU (Intel Quicksync / VAAPI)
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = false;
      };
    };
    
    # === PŘÍSTUPOVÁ PRÁVA A EXTRA PŘÍZNAKY ===
    # extraFlags nastavují nspawn tak, aby povolil přístup k hardware
    extraFlags = [ 
      "--system-call-filter=@system-service"
      "--property=DeviceAllow=char-usb_device rwm" 
      "--property=DeviceAllow=/dev/bus/usb rwm"
      "--property=DeviceAllow=/dev/dri/renderD128 rwm"
    ];

    # Zde ponecháme pouze statické uzly bez hvězdiček
    allowedDevices = [
      { node = "/dev/dri/renderD128"; modifier = "rw"; }
    ];
  };
}