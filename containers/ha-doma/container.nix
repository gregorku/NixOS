{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;
    config = import ./default.nix;

    # SÍŤ
    privateNetwork = true;
    macvlans = [ "br0" ];

    # POVOLENÍ PRO VNOŘENÝ PODMAN (Podman-in-Container)
    # enableTun: pro VPN a síťové tunely
    enableTun = true;

    # 1. Rozšířené capabilities (oprávnění)
    # CAP_SYS_ADMIN je nutný pro mountování
    # CAP_NET_ADMIN/RAW pro práci se sítí
    # CAP_IPC_LOCK pro paměť (často nutné pro databáze)
    additionalCapabilities = [
      "CAP_SYS_ADMIN"
      "CAP_MKNOD"
      "CAP_NET_ADMIN"
      "CAP_NET_RAW"
      "CAP_IPC_LOCK"
    ];

    # 2. Povolení zakázaných systémových volání (ŘEŠENÍ CHYBY BPF a KEYRING)
    # Toto řekne systemd-nspawn, aby neblokoval tyto instrukce
    extraFlags = [
      "--system-call-filter=add_key"
      "--system-call-filter=keyctl"
      "--system-call-filter=bpf"
    ];

    # 3. Mapování disků
    bindMounts = {
      "/data" = {
        hostPath = "/data";
        isReadOnly = false;
      };
      # Pokud používáte i config složku:
      # "/var/lib/ha-data" = { hostPath = "/var/lib/containers/ha-doma-data"; isReadOnly = false; };
    };
  };
}
