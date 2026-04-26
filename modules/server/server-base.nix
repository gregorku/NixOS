{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # úplné minimum
    git
    curl
    wget
    nano
    rsync

    # základní přehled
    htop
    mc

    # síť minimum (kritické při debug)
    iproute2
    iputils
  ];
}