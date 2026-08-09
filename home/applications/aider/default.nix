{ config, pkgs, ... }:

let
  aiderDataDir = "${config.home.homeDirectory}/.application-data/aider";

  aider = pkgs.writeShellScriptBin "aider" ''
    exec ${pkgs.aider-chat}/bin/aider \
      --config "${aiderDataDir}/config/aider.conf.yml" \
      "$@"
  '';
in
{
  home.packages = [
    aider
  ];

  home.activation.aiderDirectories = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${aiderDataDir}/config"
    mkdir -p "${aiderDataDir}/secrets"
    mkdir -p "${aiderDataDir}/.aider"
  '';

  home.file.".application-data/aider/config/aider.conf.yml".text = ''
    model: openrouter/anthropic/claude-sonnet-4

    git: true
    auto-commits: true
    dirty-commits: true

    disable-playwright: true
  '';
}
