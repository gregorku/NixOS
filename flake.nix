{
  description = "NixOS configuration for multiple devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Stabilní balíky pro problematické služby (Home Assistant apod.)
    nixpkgs2411.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, nixpkgs2411, ... }:
  let
    mkHost = host: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        pkgs2411 = import nixpkgs2411 {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };

      modules = [
        ./hosts/${host}/configuration.nix
      ];
    };
  in {
    nixosConfigurations = {
      ntbDell      = mkHost "ntbDell";
      domaPcServer = mkHost "domaPcServer";
      test         = mkHost "test";
      testServer   = mkHost "testServer";
    };
  };
}

