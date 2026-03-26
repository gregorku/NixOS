{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [

    # ======================
    # 📦 SYSTÉM / ZÁKLAD
    # ======================
    git
    unstable.vscodium
    nano
    mc
    btop
    duf
    fastfetch
    usbutils
    system-config-printer

    # ======================
    # 📁 SOUBORY / DISK
    # ======================
    sshfs
    gocryptfs
    krusader

    # ======================
    # 🖥️ DESKTOP / UI
    # ======================
    kitty
    crystal-dock
    gnome-calendar

    # ======================
    # 🔐 BEZPEČNOST
    # ======================
    keepassxc

    # ======================
    # 🌐 INTERNET / PROHLÍŽEČE
    # ======================
    vivaldi
    librewolf
    brave

    # ======================
    # 🌐 SÍŤ / REMOTE
    # ======================
    filezilla
    putty
    remmina
    openconnect
    vpn-slice

    # ======================
    # ☁️ CLOUD / SYNC
    # ======================
    nextcloud-client

    # ======================
    # 📥 STAHOVÁNÍ
    # ======================
    kdePackages.ktorrent

    # ======================
    # 🎬 MULTIMÉDIA / GRAFIKA
    # ======================
    vlc
    xnviewmp
    krita
    gimp

    # ======================
    # 📨 KANCELÁŘ (🔥 FIX)
    # ======================
    libreoffice-fresh
    libreoffice-qt          # 👈 KLÍČOVÉ
    onlyoffice-desktopeditors
    evolution
    pdfarranger

    # ======================
    # 🧑‍💻 EDITORY
    # ======================
    kdePackages.kate

    # ======================
    # 📄 PROHLÍŽEČE
    # ======================
    kdePackages.okular

    # ======================
    # 🗄️ DATABASE
    # ======================
    dbeaver-bin

    # ======================
    # 🌍 JAZYKY / DICTIONARIES
    # ======================
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