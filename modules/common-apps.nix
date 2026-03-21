{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    # SYSTÉM / ZÁKLAD
    git
    unstable.vscodium
    mc
    nano
    sshfs
    gocryptfs
    krusader
    crystal-dock
    gnome-calendar
    keepassxc
    system-config-printer
    usbutils
    btop

    # INTERNET / SÍTĚ
    vivaldi
    librewolf
    brave
    filezilla
    putty
    remmina
    nextcloud-client
    kdePackages.ktorrent

    # SÍTĚ
    openconnect
    vpn-slice

    # MULTIMÉDIA
    vlc
    xnviewmp
    gimp
    
    # KANCELÁŘ
    libreoffice-fresh
    onlyoffice-desktopeditors
    evolution
    pdfarranger
    kdePackages.kate
    kdePackages.okular
    dbeaver-bin

    # Jazyky
    hunspell
    hunspellDicts.cs_CZ
    aspell
    aspellDicts.cs
    
    # Poznámka: kitty, fish a starship jsou aktivovány přes programs.<name>.enable
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    corefonts
  ];
}