{ config, pkgs, ... }:

{
  users.users.gregor = {
    isNormalUser = true;
    description = "Gregor";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.bashInteractive;
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
}
