{ config, pkgs, ... }:

{
  users.users.gregor = {
    isNormalUser = true;
    description = "Gregor";
    shell = pkgs.bashInteractive;

    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };
}
