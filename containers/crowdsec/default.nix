{ secretsPath, ... }:

{
  imports = [
    "${secretsPath}/crowdsec/default.nix"
  ];

  services.crowdsec = {
    enable = true;
    webUi.enable = true;
  };

  services.crowdsec.bouncers.traefik = {
    enable = true;
    apiKeyFile = "/etc/nixos/secrets/crowdsec/env";
  };
}
