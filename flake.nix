{
  description = "NixOS configuration for multiple devices";

  inputs = {
    # 🖥️ Stable větev pro servery
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # 💻 Unstable větev pro notebooky
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ✅ Home Manager - STABLE
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ✅ Home Manager - UNSTABLE
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager-stable,
    home-manager-unstable,
    nix-flatpak,
    agenix,
    ...
  }@inputs:

  let
    system = "x86_64-linux";

    # 🖥️ Stable balíky
    stable = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # 💻 Unstable balíky
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # 🧠 mkHost
    mkHost = host: pkgsInput: hmInput: homeFile:
      pkgsInput.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs unstable stable;
        };

        modules = [
          ./hosts/${host}/configuration.nix

          # 🏠 Home Manager
          hmInput.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit unstable stable;
            };

            home-manager.users.gregor = import homeFile;
          }

          # 🔐 agenix
          agenix.nixosModules.default
        ];
      };

  in {
    nixosConfigurations = {

      # 💻 NOTEBOOKY (UNSTABLE + desktop config)
      ntbLenovo =
        mkHost "ntbLenovo"
        nixpkgs-unstable
        home-manager-unstable
        ./home/desktop.nix;

      ntbDell =
        mkHost "ntbDell"
        nixpkgs-unstable
        home-manager-unstable
        ./home/desktop.nix;

      # 🖥️ SERVERY (STABLE + server config)
      domaPcServer =
        mkHost "domaPcServer"
        nixpkgs
        home-manager-stable
        ./home/server.nix;

      VPSServer =
        mkHost "VPSServer"
        nixpkgs
        home-manager-stable
        ./home/server.nix;

      testVPSServer =
        mkHost "testVPSServer"
        nixpkgs
        home-manager-stable
        ./home/server.nix;

      test =
        mkHost "test"
        nixpkgs
        home-manager-stable
        ./home/server.nix;

      testServer =
        mkHost "testServer"
        nixpkgs
        home-manager-stable
        ./home/server.nix;

      testServerPrace =
        mkHost "testServerPrace"
        nixpkgs
        home-manager-stable
        ./home/server.nix;
    };
  };
}