{ ... }:

{
  containers.traefik = {
    autoStart = true;
    bindMounts = {
      "/run/secrets" = {
        hostPath = "/etc/nixos/secrets";
        isReadOnly = true;
      };
    };
    config = ./configuration.nix;
  };
}
