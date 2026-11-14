{
  description = "NixOS configuration for multiple devices";

  inputs = {
    # 🖥️ Stable větev pro všechny stroje
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # 📦 Unstable pouze pro vybrané aplikace
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # 💻 ntbLenovo – samostatně připnutý Nixpkgs kvůli ověřené kombinaci
    # Linux 7.2 + NVIDIA 595.99.02. Ostatní hosty používají aktuální nixpkgs.
    nixpkgs-ntbLenovo.url = "github:NixOS/nixpkgs/6f06d204d8f2d8761d9da78778745974a3216381";

    # 🏠 Home Manager - STABLE
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 📦 Flatpak modul
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # 🔐 Správa tajemství
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-ntbLenovo,
    home-manager,
    nix-flatpak,
    agenix,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # 🖥️ Stable balíčky (NixOS 26.05)
    stable = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # 📦 Unstable balíčky pouze pro jednotlivé aplikace
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # 🧠 Vytvoření hosta
    mkHost = host: homeFile: nixpkgsInput:
      nixpkgsInput.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs stable unstable;
        };

        modules = [
          ./hosts/${host}/configuration.nix

          # 🏠 Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit stable unstable;
            };

            home-manager.users.gregor = import homeFile;
          }

          # 🔐 Agenix
          agenix.nixosModules.default
        ];
      };
  in {
    nixosConfigurations = {
      # 💻 Notebooky (stable základ + možnost unstable balíčků)
      ntbLenovo = mkHost "ntbLenovo" ./home/ntbLenovo.nix nixpkgs-ntbLenovo;

      ntbDell = mkHost "ntbDell" ./home/ntbDell.nix nixpkgs;

      # 🖥️ vzdálená plocha
      pracovniPc = mkHost "pracovniPc" ./home/pracovniPc.nix nixpkgs;

      # 🖥️ Servery
      domaPcServer = mkHost "domaPcServer" ./home/server.nix nixpkgs;

      virtServerPrace = mkHost "virtServerPrace" ./home/server.nix nixpkgs;

      pracePcServer = mkHost "pracePcServer" ./home/server.nix nixpkgs;

      netcupVPSServer = mkHost "netcupVPSServer" ./home/server.nix nixpkgs;

      bratrmachServer = mkHost "bratrmachServer" ./home/server.nix nixpkgs;

      testVPSServer = mkHost "testVPSServer" ./home/server.nix nixpkgs;

      test = mkHost "test" ./home/server.nix nixpkgs;

      testServer = mkHost "testServer" ./home/server.nix nixpkgs;

      testServerPrace = mkHost "testServerPrace" ./home/server.nix nixpkgs;
    };
  };
}
