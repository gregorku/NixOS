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
    meld

    # ======================
    # 🖥️ DESKTOP / UI
    # ======================
    kitty
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
    nmap
    netdata

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
    easytag
    puddletag
    freecad

    # ======================
    # 📨 KANCELÁŘ
    # ======================
    libreoffice-qt6-fresh
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
  ];

  # ======================
  # 🔤 FONTY
  # ======================
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code

    # Microsoft kompatibilita
    corefonts

    # 🔥 Calibri / Cambria náhrady
    carlito
    caladea
  ];

  # ======================
  # 🔥 DEFAULT FONTY (SYSTEM)
  # ======================
  fonts.fontconfig.defaultFonts = {
    serif = [ "Liberation Serif" "Carlito" ];
    sansSerif = [ "Carlito" "Liberation Sans" ];
    monospace = [ "FiraCode Nerd Font" ];
  };
}
