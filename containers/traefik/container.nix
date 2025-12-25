{ ... }:

{
  containers.traefik = {
    autoStart = true;
    config = ./configuration.nix;
  };
}
