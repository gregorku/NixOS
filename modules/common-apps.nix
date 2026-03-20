{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [

    # ======================
    # 📦 SYSTÉM / ZÁKLAD (DESKTOP)
    # ======================
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
    bitwarden
    system-config-printer
    usbutils
    btop

    # ======================
    # 🌐 INTERNET / SÍTĚ
    # ======================
    vivaldi
    librewolf
    brave
    filezilla
    putty
    remmina
    nextcloud-client
    kdePackages.ktorrent

    # ======================
    # 🌐 SÍŤOVÉ NÁSTROJE
    # ======================
    openconnect
    vpn-slice

    # ======================
    # 🖥️ MULTIMÉDIA / GRAFIKA
    # ======================
    vlc
    xnviewmp
    gimp
    tidal-hifi

    # ======================
    # 📨 KANCELÁŘ / PRODUKTIVITA
    # ======================
    libreoffice-fresh
    onlyoffice-desktopeditors
    evolution
    pdfarranger
    kdePackages.kate
    kdePackages.okular
    dbeaver-bin
    obsidian

    # --- Jazyky / dictionaries ---
    hunspell
    hunspellDicts.cs_CZ
    aspell
    aspellDicts.cs
  ];
}
