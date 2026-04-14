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
    unstable.freecad

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
    # 📄 PROHLÍŽEČE DOKUMENTŮ
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
    hunspellDicts.cs_CZ  # Kontrola pravopisu
    hyphenDicts.cs_CZ    # Automatické dělení slov (důležité pro LibreOffice)

  ];

  # ======================
  # 🌐 LIBREWOLF — deklarativně přes home-manager
  # ======================
  # Pozor: tento blok patří do home-manager konfigurace (home.nix nebo podobný soubor),
  # ne do system-level modulu. Pokud ho máš zde, přesuň do home-manager modulu uživatele.
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