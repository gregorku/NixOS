{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [

    # ======================
    # 📦 SYSTÉM / ZÁKLAD
    # ======================
    git
    nvd
    unstable.vscodium
    nano
    mc
    btop
    duf
    fastfetch
    usbutils
    pciutils      # 👈 lspci (hardware debug)
    alsa-utils    # 👈 aplay, amixer (audio debug)
    system-config-printer

    # ======================
    # 📁 SOUBORY / DISK
    # ======================
    sshfs
    gocryptfs
    krusader
    kdiff3
    meld
    
    # ======================
    # 📁 SOUBORY / decompression
    # 
    unzip
    zip
    p7zip
    unrar
    xz
    gzip

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
    pkgs2511.haruna
    xnviewmp
    krita
    gimp
    easytag
    puddletag
    unstable.freecad

    # ======================
    # 📨 KANCELÁŘ
    # ======================
    libreoffice-qt6-fresh
    onlyoffice-desktopeditors
    evolution
    pdfarranger
    portfolio

    # ======================
    # 🧑‍💻 EDITORY
    # ======================
    kdePackages.kate

    # ======================
    # 📄 PROHLÍŽEČE DOKUMENTŮ
    # ======================
    kdePackages.okular

    # ======================
    # 🗄️ DATABASE
    # ======================
    dbeaver-bin
    mqtt-explorer

    # ======================
    # 🌍 JAZYKY / DICTIONARIES
    # ======================
    hunspell
    hunspellDicts.cs_CZ
    hyphenDicts.cs_CZ
  ];

  # ======================
  # 🌐 LIBREWOLF — deklarativně přes home-manager
  # ======================
  # Tento blok patří do home-manager konfigurace (home.nix), ne sem.
  # programs.librewolf = {
  #   enable = true;
  #   settings = {
  #     "intl.locale.requested"                    = "cs";
  #     "privacy.resistFingerprinting.spoofLocale" = false;
  #   };
  # };

  # ======================
  # 🔤 FONTY
  # ======================
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    corefonts
    carlito
    caladea
  ];

  fonts.fontconfig.defaultFonts = {
    serif      = [ "Liberation Serif" "Carlito" ];
    sansSerif  = [ "Carlito" "Liberation Sans" ];
    monospace  = [ "FiraCode Nerd Font" ];
  };
}