{
  description = "NixOS configuration for multiple devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
  let
    mkHost = host: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/${host}/configuration.nix

        # secretsPath přidáme jako modul, NE přes specialArgs
        ({ ... }: {
          _module.args.secretsPath = "/etc/nixos/secrets";
        })
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
