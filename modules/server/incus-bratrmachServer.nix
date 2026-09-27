{
  config,
  pkgs,
  ...
}: {
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

  users.groups.incus-admin = {};
  users.users.gregor.extraGroups = ["incus-admin"];

  environment.systemPackages = with pkgs; [
    incus
  ];

  systemd.services.incus-init = {
    description = "Incus initial setup (network + storage)";
    after = ["incus.service"];
    wantedBy = ["multi-user.target"];

    serviceConfig.Type = "oneshot";

    script = ''
      set -e
      INCUS=${pkgs.incus}/bin/incus

      echo "=== Incus init ==="

      # ----------------------
      # NAT network (incusbr0)
      # ----------------------
      if ! $INCUS network show incusbr0 >/dev/null 2>&1; then
        echo "Creating incusbr0..."
        $INCUS network create incusbr0 \
          ipv4.address=10.10.10.1/24 \
          ipv4.nat=true \
          ipv6.address=none
      else
        echo "incusbr0 already exists."
      fi

      # ----------------------
      # Default profile → existing system bridge br0
      # ----------------------
      echo "Configuring default profile to use existing br0..."

      if $INCUS profile device show default | grep -q '^eth0:'; then
        $INCUS profile device set default eth0 \
          nictype=bridged \
          parent=br0
      else
        $INCUS profile device add default eth0 nic \
          nictype=bridged \
          parent=br0
      fi
    '';
  };
}
