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

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    mkHost = host: nixpkgs.lib.nixosSystem {
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
      ntbLenovo       = mkHost "ntbLenovo";
      ntbDell         = mkHost "ntbDell";
      domaPcServer    = mkHost "domaPcServer";
      VPSServer       = mkHost "VPSServer";
      testVPSServer   = mkHost "testVPSServer";
      test            = mkHost "test";
      testServer      = mkHost "testServer";
    };
  };
}