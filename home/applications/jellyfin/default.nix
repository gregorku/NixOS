#
# Jellyfin Desktop
#
# Hlavní modul aplikace.
#
# Přidává:
#   • instalaci programu
#   • launcher
#   • přesměrování uživatelských dat
#

{
  imports = [
    ./launcher.nix
    ./application-data.nix
  ];
}