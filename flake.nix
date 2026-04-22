{
  description = "NixOS configuration for multiple devices";

  inputs = {
    # 🖥️ Stable větev pro servery
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    # 💻 Unstable větev pro notebooky
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ✅ Home Manager - STABLE (pro servery)
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ✅ Home Manager - UNSTABLE (pro notebooky)
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # nix-flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # agenix
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager-stable, home-manager-unstable, nix-flatpak, agenix, ... }@inputs:
  let
    system = "x86_64-linux";

    # 📦 Unstable balíčky (pro sdílení např. v Home Manageru)
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # 🧠 Funkce pro vytvoření hosta
    mkHost = host: pkgsInput: hmInput:
      pkgsInput.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs unstable;
        };

        modules = [
          ./hosts/${host}/configuration.nix

          # 🏠 Home Manager
          hmInput.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit unstable; };

            home-manager.users.gregor = import ./home/gregor.nix;
          }

          # 🔐 agenix
          agenix.nixosModules.default
        ];
      };

  in {
    nixosConfigurations = {

      # 💻 NOTEBOOKY (UNSTABLE)
      ntbLenovo = mkHost "ntbLenovo" nixpkgs-unstable home-manager-unstable;
      ntbDell   = mkHost "ntbDell" nixpkgs-unstable home-manager-unstable;

      # 🖥️ SERVERY (STABLE)
      domaPcServer    = mkHost "domaPcServer" nixpkgs home-manager-stable;
      VPSServer       = mkHost "VPSServer" nixpkgs home-manager-stable;
      testVPSServer   = mkHost "testVPSServer" nixpkgs home-manager-stable;
      test            = mkHost "test" nixpkgs home-manager-stable;
      testServer      = mkHost "testServer" nixpkgs home-manager-stable;
      testServerPrace = mkHost "testServerPrace" nixpkgs home-manager-stable;
    };
  };
}