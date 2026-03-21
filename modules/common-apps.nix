{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    unstable.vscodium
    mc
    nano
    sshfs
    gocryptfs
    krusader
    crystal-dock
    kitty
    gnome-calendar
    keepassxc
    system-config-printer
    usbutils
    btop
    vivaldi
    librewolf
    brave
    filezilla
    putty
    remmina
    nextcloud-client
    kdePackages.ktorrent
    openconnect
    vpn-slice
    vlc
    xnviewmp
    gimp
    libreoffice-fresh
    onlyoffice-desktopeditors
    evolution
    pdfarranger
    kdePackages.kate
    kdePackages.okular
    dbeaver-bin
    hunspell
    hunspellDicts.cs_CZ
    aspell
    aspellDicts.cs
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    corefonts
  ];
}