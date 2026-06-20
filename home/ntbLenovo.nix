{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./menu/ntbLenovo/gocryptfs.nix
    ./menu/ntbLenovo/vzdalena-plocha.nix
    ./menu/ntbLenovo/applications-kmenuedit.nix
    ./menu/ntbLenovo/ssh.nix
    ./menu/ntbLenovo/kamery.nix
  ];
}