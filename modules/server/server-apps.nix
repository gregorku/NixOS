{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # komfort / práce
    vim
    btop
    tmux

    # síť / debug
    tcpdump
    nmap

    # systémové nástroje
    lsof
    strace
    file
    tree

    # hardware / monitoring
    smartmontools
    lm_sensors
    usbutils
  ];
}