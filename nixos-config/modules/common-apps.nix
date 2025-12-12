{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libreoffice-fresh
    vivaldi
    librewolf
    brave
    vlc
    filezilla
    putty
    sshfs
    gocryptfs
    remmina
    xnviewmp
    evolution
    nextcloud-client
    gitkraken
    ];
}
