{ lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;
    config = import ./default.nix;
    privateNetwork = true;
    macvlans = [ "br0" ];

    # DŮLEŽITÉ: Povolení vnořené virtualizace a TUN pro Podman
    enableTun = true;
    # Doplníme bindMounts, pokud byste později potřebovali
    # sdílet data z hostitele přímo do vnořených kontejnerů

    # DŮLEŽITÉ: Přidání oprávnění pro vnořené kontejnery
    additionalCapabilities = [ "CAP_SYS_ADMIN" "CAP_MKNOD" ];

    # MAPOVÁNÍ DATAPOOLU (Hostitel -> Kontejner)
    bindMounts = {
      "/data" = {
        hostPath = "/data";
        isReadOnly = false;
      };
    };
  };
}
