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
  ];

  # Nix tooling (flake workflow)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # DŮLEŽITÉ: Toto musí být v každém systému
  system.stateVersion = "25.05";  # nebo "24.05" podle vaší verze
}
