{ config, pkgs, ... }:

let
  aiderDataDir = "${config.home.homeDirectory}/.application-data/aider";
  aiderSecret = "/run/agenix/aider-openrouter";

  aider = pkgs.writeShellScriptBin "aider" ''
    export HOME="${aiderDataDir}"

    if [ ! -r "${aiderSecret}" ]; then
      echo "ERROR: Aider OpenRouter secret is not available:" >&2
      echo "       ${aiderSecret}" >&2
      exit 1
    fi

    set -a
    . "${aiderSecret}"
    set +a

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

    input-history-file: ${aiderDataDir}/.aider/input.history
    chat-history-file: ${aiderDataDir}/.aider/chat.history.md
    llm-history-file: ${aiderDataDir}/.aider/llm.history
  '';
}
