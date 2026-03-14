{
  description = "NixOS configuration for multiple devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
  let
    mkHost = host: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
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
