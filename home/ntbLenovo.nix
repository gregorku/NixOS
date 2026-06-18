{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./menu/ntbLenovo/vzdalena-plocha.nix
    ./menu/ntbLenovo/applications-kmenuedit.nix
    #./nabidka-kde.nix
  ];
}