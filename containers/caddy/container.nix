{ ... }:

{
  containers.caddy = {
    autoStart = true;
    config = ./configuration.nix;
  };
}
