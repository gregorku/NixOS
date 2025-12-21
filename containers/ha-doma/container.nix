{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true; [cite: 5]

    # Import vnitřní konfigurace
    config = import ./default.nix; [cite: 6]

    # SÍŤ – Propojení s existujícím br0 na hostiteli
    privateNetwork = true;
    macvlans = [ "br0" ];

    # Povolení TUN/TAP zařízení
    enableTun = true; [cite: 8]
  };
}
