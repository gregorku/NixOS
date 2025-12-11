{
  description = "NixOS configuration for multiple devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      ntbLenovo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/ntbLenovo/configuration.nix ];
      };
      ntbDell = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/ntbDell/configuration.nix ];
      };
      pracovniPc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/pracovniPc/configuration.nix ];
      };
    };
  };
}
