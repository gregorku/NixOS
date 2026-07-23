{ config, pkgs, ... }:

{
  home.username = "gregor";
  home.homeDirectory = "/home/gregor";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
  ];
}