{
  description = "NixOS configuration for multiple devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # 1. Přidání zdroje pro nix-flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  # 2. Přidání nix-flatpak do argumentů outputs a zachycení @inputs
  outputs = { self, nixpkgs, nixpkgs-unstable, nix-flatpak, ... }@inputs:
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
        # 3. Předání 'inputs' do modulů, aby common-flatpak.nix mohl modul načíst
        inherit inputs unstable;
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