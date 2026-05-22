{ config, pkgs, ... }:

{
  # Povolit non-free globálně (bez GUI vazby)
  nixpkgs.config.allowUnfree = true;

  # ZÁKLAD – opravdu jen minimum
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    nano
    rsync
    tmux
    mc
  ];

  # Nix tooling (flake workflow)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
