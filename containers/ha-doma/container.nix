{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;

    # Importuje vnitřní nastavení ze souboru default.nix
    config = import ./default.nix;

    # SÍŤ – Bridge (bez NAT)
    # privateNetwork = true vytvoří pro kontejner vlastní síťový prostor
    privateNetwork = true;
    # macvlans propojí kontejner přímo s fyzickým bridge br0
    macvlans = [ "br0" ];

    # Povolení TUN zařízení
    enableTun = true;
  };
}
