{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # základ
    git
    vim
    nano
    htop
    btop
    tmux
    curl
    wget
    rsync
    mc

    # síť / debug
    iproute2
    iputils
    tcpdump
    nmap

    # monitoring / utils
    lsof
    strace
    file
    tree
    smartmontools
    lm_sensors
  ];
}
