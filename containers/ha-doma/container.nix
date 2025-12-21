{ config, lib, ... }:

{
  containers.ha-doma = {
    autoStart = true;

    config = {
      networking.hostName = "ha-doma";
    };
  };
}
