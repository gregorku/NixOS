{ inputs, ... }: # Tady přijímáme 'inputs' ze specialArgs

{
  # Import modulu přímo z flake inputu
  imports = [ inputs.nix-flatpak.nixosModules.default ];

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