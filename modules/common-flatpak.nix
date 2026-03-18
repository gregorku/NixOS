{ inputs, ... }:

{
  # Import modulu definovaného ve tvém flake.nix
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    # Nastavení repozitářů
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    # Seznam aplikací
    packages = [
      "nz.mega.MEGAsync"           # Cloudové úložiště
      "com.github.tchx84.Flatseal" # Správce oprávnění pro Flatpaky
    ];

    # Automatické aktualizace (jednou týdně)
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}