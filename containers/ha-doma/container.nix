{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;

    ##################################################
    # KONFIGURACE KONTEJNERU (JEDINÉ MÍSTO)
    ##################################################
    config = import ./default.nix;

    ##################################################
    # SÍŤ – BRIDGE (bez NAT)
    ##################################################
    privateNetwork = false;

    enableTun = true;
    enableTunTap = true;
  };
}
