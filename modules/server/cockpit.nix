services.cockpit = {
  enable = true;
  openFirewall = true;
  settings = {
    WebService = {
      AllowUnencrypted = true;
      ProtocolHeader = "X-Forwarded-Proto";
    };
  };
};
