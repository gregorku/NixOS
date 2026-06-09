{
  description = "NixOS configuration for multiple devices";

  inputs = {
    # 🖥️ Stable větev pro všechny stroje
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # 📦 Unstable pouze pro vybrané aplikace
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # 🏠 Home Manager - STABLE
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 📦 Flatpak modul
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # 🔐 Správa tajemství
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-flatpak,
    agenix,
    ...
  }@inputs:

  let
    system = "x86_64-linux";

    # 🖥️ Stable balíčky (NixOS 26.05)
    stable = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # 📦 Unstable balíčky pouze pro jednotlivé aplikace
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # 🧠 Vytvoření hosta
    mkHost = host: homeFile:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs stable unstable;
        };

        modules = [
          ./hosts/${host}/configuration.nix

          # 🏠 Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit stable unstable;
            };

            home-manager.users.gregor = import homeFile;
          }

          # 🔐 Agenix
          agenix.nixosModules.default
        ];
      };

  in {
    nixosConfigurations = {

      # 💻 Notebooky (stable základ + možnost unstable balíčků)
      ntbLenovo =
        mkHost "ntbLenovo"
        ./home/desktop.nix;

      ntbDell =
        mkHost "ntbDell"
        ./home/desktop.nix;

      pracovniPc =
        mkHost "pracovniPc"
        ./home/desktop.nix;        

      # 🖥️ Servery
      domaPcServer =
        mkHost "domaPcServer"
        ./home/server.nix;

      VPSServer =
        mkHost "VPSServer"
        ./home/server.nix;

      testVPSServer =
        mkHost "testVPSServer"
        ./home/server.nix;

      test =
        mkHost "test"
        ./home/server.nix;

      testServer =
        mkHost "testServer"
        ./home/server.nix;

      testServerPrace =
        mkHost "testServerPrace"
        ./home/server.nix;
    };
  };
}