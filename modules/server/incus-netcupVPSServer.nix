{ config, pkgs, ... }:

{
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    package = pkgs.incus;
  };

  users.groups.incus-admin = {};

  users.users.gregor.extraGroups = [
    "incus-admin"
  ];

  environment.systemPackages = with pkgs; [
    incus
  ];

  systemd.services.incus-init = {
    description = "Incus initial setup";

    after = [
      "incus.service"
      "network-online.target"
    ];

    wants = [
      "network-online.target"
    ];

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = ''
      set -e

      INCUS=${pkgs.incus}/bin/incus

      echo "=== Incus init ==="

      # ----------------------
      # NAT network (incusbr0)
      # ----------------------
      if ! $INCUS network list | grep -q '^| incusbr0 '; then
        echo "Creating incusbr0..."

        $INCUS network create incusbr0 \
          ipv4.address=10.10.10.1/24 \
          ipv4.nat=true \
          ipv6.address=none
      fi

      # ----------------------
      # Default storage (dir)
      # ----------------------
      if ! $INCUS storage list | grep -q '^| default '; then
        echo "Creating default dir storage..."

        $INCUS storage create default dir
      fi

      # ----------------------
      # Default profile
      # ----------------------
      echo "Configuring default profile..."

      if ! $INCUS profile device show default | grep -q '^eth0:'; then
        echo "Creating eth0 device..."

        $INCUS profile device add default eth0 nic \
          network=incusbr0 \
          name=eth0
      else
        echo "Updating eth0 device..."

        $INCUS profile device set default eth0 \
          network=incusbr0
      fi
    '';
  };
}