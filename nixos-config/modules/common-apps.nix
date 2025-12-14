{ config, pkgs, ... }:

{
  # ----------------------------------
  # Allow unfree packages (NVIDIA, browsers, etc.)
  # ----------------------------------
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

    # ======================
    # 📦 SYSTÉM / ZÁKLAD
    # ======================
    git
    gitkraken
    sshfs
    gocryptfs
    krusader
    crystal-dock
    gnome-calendar
    keepassxc
    system-config-printer

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
    evolution
    pdfarranger
    kdePackages.kate
    kdePackages.okular
  ];
}
