{ config, pkgs, ... }:

{
  users.users.gregor = {
    isNormalUser = true;
    description = "Gregor";
    shell = pkgs.fish;  # 👈 změna tady

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