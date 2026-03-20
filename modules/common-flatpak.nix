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
      "nz.mega.MEGAsync"             # Cloudové úložiště
      "com.github.tchx84.Flatseal"   # Správce oprávnění pro Flatpaky
      "com.mastermindzh.tidal-hifi"  # TIDAL (funkční verze přes Flatpak)
      "md.obsidian.Obsidian"         # Obsidian (novější než nixpkgs)
      "com.bitwarden.desktop"        # Bitwarden (aktuální verze)
      "org.localsend.localsend_app"  # Sdílení souborů (AirDrop-like)
    ];

    # Automatické aktualizace (jednou týdně)
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}