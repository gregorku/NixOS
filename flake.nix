{
  description = "NixOS configuration for multiple devices";

  inputs = {
    # Hlavní větev – 25.11
    nixpkgs = {
      url = "tarball+https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-25.11.tar.gz";
    };

    # Stabilní balíky – 24.11 (Home Assistant, ESPHome, MQTT…)
    nixpkgs2411 = {
      url = "tarball+https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-24.11.tar.gz";
    };
  };

  outputs = { self, nixpkgs, nixpkgs2411, ... }:
  let
    mkHost = host: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        # 🔑 ZDE se pkgs2411 zavede do _module.args
        {
          _module.args.pkgs2411 = import nixpkgs2411 {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        }

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
