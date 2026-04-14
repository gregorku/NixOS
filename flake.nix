{
  description = "NixOS configuration for multiple devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # agenix
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, agenix, ... }@inputs:
  let
    system = "x86_64-linux";

    # unstable definice pro specialArgs zůstává (pro případ, že ji potřebuješ u serverů)
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # 🔥 ZMĚNA: mkHost teď přijímá i 'pkgsInput' (což bude buď nixpkgs nebo nixpkgs-unstable)
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
      # 💻 DESKTOPY A NOTEBOOKY (UNSTABLE)
      # Předáváme nixpkgs-unstable
      ntbLenovo       = mkHost "ntbLenovo" nixpkgs-unstable;
      ntbDell         = mkHost "ntbDell" nixpkgs-unstable;

      # 🖥️ SERVERY (STABLE)
      # Předáváme klasické nixpkgs
      domaPcServer    = mkHost "domaPcServer" nixpkgs;
      VPSServer       = mkHost "VPSServer" nixpkgs;
      testVPSServer   = mkHost "testVPSServer" nixpkgs;
      test            = mkHost "test" nixpkgs;
      testServer      = mkHost "testServer" nixpkgs;
    };
  };
}