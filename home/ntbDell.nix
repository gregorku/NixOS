{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./menu/ntbDell/gocryptfs.nix
    ./menu/ntbDell/vzdalena-plocha.nix
    ./menu/ntbDell/applications-kmenuedit.nix
    ./menu/ntbDell/vpn.nix
    ./menu/ntbDell/ssh.nix
    ./menu/ntbDell/hdd.nix
    ./menu/ntbDell/kamery.nix
    ./menu/ntbDell/programy.nix
  ];
}