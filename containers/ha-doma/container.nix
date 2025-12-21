{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true; # [cite: 5]

    # Konfigurace kontejneru
    config = import ./default.nix; # [cite: 6]

    # SÍŤ – Propojení s existujícím br0 na hostiteli
    privateNetwork = true;
    macvlans = [ "br0" ];

    # Povolení tunelu (pokud je potřeba pro HA/VPN)
    enableTun = true; # [cite: 8]
    enableTunTap = true; # [cite: 8]
  };
}
