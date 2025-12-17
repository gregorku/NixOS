{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    systemd
  ];
}
