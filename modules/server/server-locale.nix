{ ... }:

{
  i18n = {
    defaultLocale = "cs_CZ.UTF-8";

    supportedLocales = [
      "cs_CZ.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_TIME = "cs_CZ.UTF-8";
      LC_MONETARY = "cs_CZ.UTF-8";
      LC_NUMERIC = "cs_CZ.UTF-8";
      LC_COLLATE = "cs_CZ.UTF-8";
    };
  };

  time.timeZone = "Europe/Prague";
}