{ config, pkgs, ... }:

{
  # ----------------------
  # Incus
  # ----------------------
  virtualisation.incus = {
    enable = true;

    # Web UI
    ui.enable = true;

    # ----------------------
    # Storage (ZFS)
    # ----------------------
    storage = {
      enable = true;

      pools = {
        default = {
          driver = "zfs";
          source = "zfs-pool-incus/incus";
        };
      };
    };

    # ----------------------
    # Network (NAT bridge)
    # ----------------------
    network = {
      enable = true;

      bridge = "incusbr0";

      ipv4.address = "10.10.10.1/24";
      ipv4.nat = true;

      ipv6.address = "none";
    };
  };

  # ----------------------
  # Skupiny / přístup
  # ----------------------
  users.groups.incus-admin = {};

  # přidej si uživatele (uprav podle potřeby)
  users.users.gregor.extraGroups = [ "incus-admin" ];

  # ----------------------
  # CLI nástroje
  # ----------------------
  environment.systemPackages = with pkgs; [
    incus
  ];
}