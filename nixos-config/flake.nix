{
  description = "NixOS configuration for multiple devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
  {
    nixosConfigurations = {
      ntbDell = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/ntbDell/configuration.nix
        ];
      };

      ntbLenovo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/ntbLenovo/configuration.nix
        ];
      };

      pracovniPc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pracovniPc/configuration.nix
        ];
      };

      test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/test/configuration.nix
        ];
      };

      # ⬇⬇⬇ NOVÝ SERVER (VM test)
      testServer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/testServer/configuration.nix
        ];
      };
    };
  };
}
