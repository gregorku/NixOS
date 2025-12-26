{ ... }:

{
  containers.caddy = {
    autoStart = true;
    ephemeral = true; # Doporučeno pro čisté starty

    # Aktivuje izolovanou síť pro kontejner
    privateNetwork = true;
    # Vytvoří macvlan rozhraní z fyzické karty hostitele
    # Nahraď 'eth0' skutečným názvem tvé karty
    macvlans = [ "br0" ];
    bindMounts = {
    "/etc/caddy" = {
      hostPath = "/data/caddy/config";
      isReadOnly = false;
    };
    "/var/lib/caddy" = {
      hostPath = "/data/caddy/data";
      isReadOnly = false;
    };
    config = ./default.nix.nix;
    };
  };
}
