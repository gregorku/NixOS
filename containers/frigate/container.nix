{ config, pkgs, ... }:

{
  containers.frigate = {
    autoStart = true;
    ephemeral = true; # Při restartu se systém resetuje, data zůstanou v bind mountech
    config = import ./frigate-default.nix;

    # === SÍŤ ===
    # Aktivuje izolovanou síť a vytvoří macvlan z bridge (br0)
    privateNetwork = true;
    macvlans = [ "br0" ]; 

    # === ÚLOŽIŠTĚ A HARDWARE ===
    bindMounts = {
      # Konfigurace a databáze Frigate
      "/var/lib/frigate" = {
        hostPath = "/data/frigate";
        isReadOnly = false;
      };
      # PŘIDEJTE TENTO ŘÁDEK:
      "/dev/shm" = { 
        hostPath = "/dev/shm"; 
        isReadOnly = false; 
      };
      # Nahrávky a klipy
      "/media/frigate" = {
        hostPath = "/video";
        isReadOnly = false;
      };
      # Přístup ke Google Coral (USB)
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
    
    # Povolení přístupu k zařízením pro kontejner
    extraFlags = [ "--system-call-filter=@system-service" ];
    allowedDevices = [
      { node = "/dev/dri/renderD128"; modifier = "rw"; }
      { node = "/dev/bus/usb"; modifier = "rw"; }
    ];
  };
}