{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;
    # Vypneme soukromou síť, aby kontejner mohl sdílet rozhraní hostitele nebo bridge
    privateNetwork = true;

    # Propojení s vaším bridge na serveru
    interfaces = [ "eth0" ]; # virtuální rozhraní v kontejneru
    bridge = "br0";          # fyzický bridge na vašem hostiteli

    config = import ./default.nix;
  };
}
