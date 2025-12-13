{
  description = "NixOS configuration for multiple devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }:
  {
    nixosConfigurations = {
      ntbDell = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/ntbDell/hardware-configuration.nix
          ./hosts/ntbDell/configuration.nix
        ];
      };

      ntbLenovo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/ntbLenovo/hardware-configuration.nix
          ./hosts/ntbLenovo/configuration.nix
        ];
      };

      pracovniPc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pracovniPc/hardware-configuration.nix
          ./hosts/pracovniPc/configuration.nix
        ];
      };
    };
  };
}
