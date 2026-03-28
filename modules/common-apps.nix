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
    tilix
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
    easytag
    puddletag

    # ======================
    # 📨 KANCELÁŘ (🔥 FIX)
    # ======================
    libreoffice-fresh
    libreoffice-qt
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

  # ======================
  # 🔤 FONTY (🔥 DŮLEŽITÉ)
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
    serif = [ "Times New Roman" "Liberation Serif" ];
    sansSerif = [ "Arial" "Carlito" "Liberation Sans" ];
    monospace = [ "FiraCode Nerd Font" ];
  };
}