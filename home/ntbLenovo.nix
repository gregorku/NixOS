{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./menu/ntbLenovo/vzdalena-plocha.nix
    #./nabidka-kde.nix
  ];
}