{ config, pkgs, ... }:

{
  home.username = "gregor";
  home.homeDirectory = "/home/gregor";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    mutableExtensionsDir = true;

    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
      ms-python.python
      yzhang.markdown-all-in-one
    ];

    userSettings = {
      "editor.minimap.enabled" = false;
      "editor.tabSize" = 2;
      "files.autoSave" = "afterDelay";

      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings.nil.formatting.command" = [ "nixfmt" ];
    };
  };
}