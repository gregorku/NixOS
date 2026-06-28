{
  description = "nixos-update development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            git
            gnumake
            shellcheck
            shfmt
            ripgrep
            fd
            jq
          ];

          shellHook = ''
            echo
            echo "==========================================="
            echo "  nixos-update development environment"
            echo "==========================================="
            echo
            echo "Available tools:"
            echo "  bash        $(bash --version | head -n1)"
            echo "  git         $(git --version)"
            echo "  shellcheck  $(shellcheck --version | head -n1)"
            echo "  shfmt       $(shfmt --version)"
            echo
          '';
        };
      });
}