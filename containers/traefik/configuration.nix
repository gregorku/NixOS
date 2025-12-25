services.traefik = {
  enable = true;
  environmentFiles = [ "/run/secrets/crowdsec/env" ];

  staticConfigOptions.experimental.plugins.crowdsec = {
    moduleName = "github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin";
    version = "v1.4.2";
  };

  dynamicConfigOptions.http.middlewares.crowdsec.plugin.crowdsec = {
    enabled = true;
    crowdsecLapiKey = "$CROWDSEC_BOUNCER_API_KEY";
    crowdsecLapiUrl = "http://192.168.100.1:8080";
  };
};
