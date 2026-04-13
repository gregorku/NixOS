{ config, pkgs, unstable, ... }:

{
  home.username = "gregor";
  home.homeDirectory = "/home/gregor";
  home.stateVersion = "25.11";

  # ======================
  # 🌐 LIBREWOLF
  # ======================
  programs.librewolf = {
  enable = true;
  settings = {
    "intl.locale.requested"                    = "cs";
    "intl.multilingual.enabled"                = false;
    "privacy.resistFingerprinting.spoofLocale" = false;
  };
};
}