{ config, pkgs, ... }:

let
  # Definice modulu (stáhne se automaticky z GitHubu)
  nix-flatpak = builtins.fetchTarball {
    url = "https://github.com/gmodena/nix-flatpak/archive/main.tar.gz";
  };
in
{
  imports = [ nix-flatpak ];

  services.flatpak = {
    enable = true;

    # Automaticky přidá Flathub repo (nemusíš psát systemd službu)
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    # Deklarativní seznam aplikací (žádné ExecStart ani bash skripty)
    packages = [
      "flathub:nz.mega.MEGAsync"
    ];

    # Volitelné: Automatické aktualizace
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}