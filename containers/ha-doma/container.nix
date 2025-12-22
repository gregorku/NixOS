{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;
    config = import ./default.nix;
    privateNetwork = true;
    macvlans = [ "br0" ];

    enableTun = true;

    # Klíčové nastavení pro rootless podman uvnitř nspawn kontejneru:
    # Umožní kontejneru mapovat vlastní uživatele
    ephemeral = false;

    additionalCapabilities = [
      "CAP_SYS_ADMIN"
      "CAP_MKNOD"
      "CAP_NET_ADMIN"
      "CAP_NET_RAW"
      "CAP_IPC_LOCK"
      "CAP_SETGID" # Nutné pro rootless podman
      "CAP_SETUID" # Nutné pro rootless podman
    ];

    extraFlags = [
      "--system-call-filter=add_key"
      "--system-call-filter=keyctl"
      "--system-call-filter=bpf"
    ];

    bindMounts = {
      "/data" = { hostPath = "/data"; isReadOnly = false; };
    };
  };
}
