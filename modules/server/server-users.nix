# modules/server-users.nix

{ config, pkgs, ... }:

{
  ##################################################
  # Skupiny
  ##################################################

  users.groups.gregor = { };

  ##################################################
  # Uživatel Gregor
  ##################################################

  users.users.gregor = {
    isNormalUser = true;
    description = "Server administrator";

    group = "gregor";

    extraGroups = [
      "wheel"
      "incus-admin"
    ];

    shell = pkgs.bashInteractive;

    linger = true;

    initialPassword = "zmenit";

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2E..."
    ];
  };
}