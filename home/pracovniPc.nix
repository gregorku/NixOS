{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./menu/pracovniPc/gocryptfs.nix
    ./menu/pracovniPc/vzdalena-plocha.nix
    ./menu/pracovniPc/applications-kmenuedit.nix
    ./menu/pracovniPc/vpn.nix
    ./menu/pracovniPc/ssh.nix
    ./menu/pracovniPc/hdd.nix
    ./menu/pracovniPc/kamery.nix
  ];
}