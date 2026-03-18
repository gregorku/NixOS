{ config, pkgs, ... }:

let
  # Stažení komunitního modulu nix-flatpak s kontrolním součtem (SHA256)
  nix-flatpak = builtins.fetchTarball {
    url = "https://github.com/gmodena/nix-flatpak/archive/main.tar.gz";
    sha256 = "1m6r93nm60563n7pzk8p7s8m0khw4v8f09r5mclm63c1q06b47z8";
  };
in
{
  # Import staženého modulu
  imports = [ nix-flatpak ];

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
    # Formát: "název_remotu:ID_aplikace"
    packages = [
      "flathub:nz.mega.MEGAsync"
    ];

    # Volitelné: Nastavení automatických aktualizací
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # aktualizovat jednou týdně
    };
  };

  # Poznámka: Původní systemd služby flatpak-repo a flatpak-install 
  # byly odstraněny, protože nix-flatpak je nahrazuje interně.
}