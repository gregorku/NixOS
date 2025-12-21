{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;
    # [cite_start]Musí být true, aby kontejner měl vlastní síťový stack oddělený od hostitele [cite: 7]
    privateNetwork = true;

    # Toto vytvoří v kontejneru rozhraní (typicky mv-br0),
    # které je transparentně propojené s vaším domácím bridge
    macvlans = [ "br0" ];

    # [cite_start]Ponecháme import vaší vnitřní konfigurace [cite: 6]
    config = import ./default.nix;

    # [cite_start]Ponecháno dle původního zadání [cite: 8]
    enableTun = true;
  };
}
