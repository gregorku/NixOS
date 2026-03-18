{ inputs, ... }:

{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    # 🔧 OPRAVA: Odstraněna dvojtečka a název remota
    packages = [
      "nz.mega.MEGAsync"
    ];

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}