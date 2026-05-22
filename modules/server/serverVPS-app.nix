{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # komfort / práce
    vim
    btop
    tmux

    # rozšířený síťový debug
    tcpdump
    nmap

    # systémové nástroje
    lsof
    strace
    file
    tree
    nvd

    # hardware / monitoring
    smartmontools
    lm_sensors
    usbutils
  ];
}