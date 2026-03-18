{ config, pkgs, ... }:

let
  # Stažení komunitního modulu nix-flatpak
  nix-flatpak = builtins.fetchTarball {
    url = "https://github.com/gmodena/nix-flatpak/archive/main.tar.gz";
    sha256 = "0gpn5fval9b74fqf6aarzvdrf3qb28c6mx0jxxka3i0wpggp9f29";
  };
in
{
  # ⚠️ Změna tady: musíme odkázat přímo na soubor module.nix
  imports = [ "${nix-flatpak}/module.nix" ];

  services.flatpak = {
    enable = true;

    # Deklarativní správa repozitářů
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    # Seznam aplikací k instalaci
    packages = [
      "flathub:nz.mega.MEGAsync"
    ];

    # Volitelné: Nastavení automatických aktualizací
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}