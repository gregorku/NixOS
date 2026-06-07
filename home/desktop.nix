programs.librewolf = {
  enable = true;
  languagePacks = [ "cs" ];

  settings = {
    "intl.locale.requested" = "cs";
    "intl.multilingual.enabled" = false;
    "privacy.resistFingerprinting.spoofLocale" = false;

    # Firefox Standard místo Strict
    "browser.contentblocking.category" = "standard";
  };
};