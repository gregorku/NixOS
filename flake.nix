{
  description = "NixOS configuration for multiple devices";

  inputs = {
    # Hlavní větev – 25.11
    nixpkgs.url = "tarball+https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-25.11.tar.gz";

    # Stabilní balíky – 24.11 (Home Assistant, MQTT, ESPHome…)
    nixpkgs2411.url = "tarball+https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-24.11.tar.gz";
  };

  outputs = { self, nixpkgs, nixpkgs2411, ... }:
  let
    system = "x86_64-linux";

    pkgs2411 = import nixpkgs2411 {
      inherit system;
      config.allowUnfree = true;
    };

    mkHost = host: nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        # 🔑 ZDE SE PKGS2411 VLOŽÍ DO _module.args
        ({ ... }: {
          _module.args.pkgs2411 = pkgs2411;
        })

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
