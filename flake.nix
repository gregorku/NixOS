{
  description = "NixOS configuration for multiple devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }:
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
        inherit unstable;
      };

      modules = [
        ./hosts/${host}/configuration.nix
      ];
    };

  in {
    nixosConfigurations = {
      ntbLenovo    = mkHost "ntbLenovo";
      ntbDell      = mkHost "ntbDell";
      domaPcServer = mkHost "domaPcServer";
      test         = mkHost "test";
      testServer   = mkHost "testServer";
    };
  };
}
