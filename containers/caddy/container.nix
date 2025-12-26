{ ... }:

{
  containers.caddy = {
    autoStart = true;
    ephemeral = true; # Doporučeno pro čisté starty

    # Aktivuje izolovanou síť pro kontejner
    privateNetwork = true;
    # Vytvoří macvlan rozhraní z fyzické karty hostitele
    # Nahraď 'eth0' skutečným názvem tvé karty
    macvlans = [ "eth0" ];

    config = ./configuration.nix;
  };
}
