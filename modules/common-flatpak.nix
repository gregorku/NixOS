{ inputs, ... }:

{
  # 🔧 Oprava: Změna z .default na .nix-flatpak
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      "flathub:nz.mega.MEGAsync"
    ];

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}