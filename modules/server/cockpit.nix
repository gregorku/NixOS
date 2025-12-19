{
  services.cockpit = {
    enable = true;
    openFirewall = true; # I když je globální FW vypnutý, nechte toto true
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };
}
