{
  description = "NixOS configuration for multiple devices";

  inputs = {
    # Stabilní větev pro servery
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    # Unstable větev pro notebooky (aktuálně směřuje k 26.05)
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager - přepnuto na master (unstable), aby seděl k Nixpkgs 26.05
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # nix-flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # agenix
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, agenix, ... }@inputs:
  let
    system = "x86_64-linux";

    # Definice balíčků pro unstable (využívá se v specialArgs)
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # Pomocná funkce pro definici hostitele
    # pkgsInput určuje, zda bude systém postaven na stable nebo unstable větvi
    mkHost = host: pkgsInput: pkgsInput.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs unstable;
      };

      modules = [
        ./hosts/${host}/configuration.nix

        # home-manager modul
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit unstable; };
          home-manager.users.gregor = import ./home/gregor.nix;
        }

        # agenix modul
        agenix.nixosModules.default
      ];
    };

  in {
    nixosConfigurations = {
      # 💻 DESKTOPY A NOTEBOOKY (UNSTABLE - KDE Plasma 6.6+)
      # Tyto stroje poletí na nejnovější vlně balíčků
      ntbLenovo       = mkHost "ntbLenovo" nixpkgs-unstable;
      ntbDell         = mkHost "ntbDell" nixpkgs-unstable;

      # 🖥️ SERVERY (STABLE - Konzervativní 25.11)
      # Zde zůstává maximální stabilita a prověřené verze
      domaPcServer    = mkHost "domaPcServer" nixpkgs;
      VPSServer       = mkHost "VPSServer" nixpkgs;
      testVPSServer   = mkHost "testVPSServer" nixpkgs;
      test            = mkHost "test" nixpkgs;
      testServer      = mkHost "testServer" nixpkgs;
      testServerPrace = mkHost "testServerPrace" nixpkgs;
    };
  };
}