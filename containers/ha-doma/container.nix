{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;

    # Importuje vnitřní nastavení ze souboru default.nix
    config = import ./default.nix;

    # Propojení s bridge rozhraním br0 na hostiteli
    privateNetwork = true;
    macvlans = [ "br0" ];

    # Povolení TUN zařízení (nutné pro některé síťové funkce)
    enableTun = true;
  };
}
