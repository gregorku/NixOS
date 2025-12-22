{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;
    config = import ./default.nix;
    privateNetwork = true;
    macvlans = [ "br0" ];

    enableTun = true;

    # Klíčové nastavení pro podman uvnitř nspawn kontejneru
    ephemeral = false;

    additionalCapabilities = [
      "CAP_SYS_ADMIN"
      "CAP_MKNOD"
      "CAP_NET_ADMIN"
      "CAP_NET_RAW"
      "CAP_IPC_LOCK"
      "CAP_SETGID"
      "CAP_SETUID"
    ];

    extraFlags = [
      "--system-call-filter=add_key"
      "--system-call-filter=keyctl"
      "--system-call-filter=bpf"
    ];

    # MAPOVÁNÍ DISKŮ A USB ZAŘÍZENÍ
    bindMounts = {
      "/data" = {
        hostPath = "/data";
        isReadOnly = false;
      };

      # Mapování Zigbee koordinátoru SMLIGHT pomocí unikátního ID
      "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0" = {
        hostPath = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07Mg24_0ab50f4025adef1196c58a4ba8793231-if00-port0";
        isReadOnly = false;
      };
    };
  };
}
