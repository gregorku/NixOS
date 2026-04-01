{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Základ
    git vim nano htop btop tmux curl wget rsync mc unzip

    # Síť / debug
    iproute2 iputils tcpdump nmap
    netcat-openbsd  # nc
    dig             # DNS
    mtr             # traceroute + ping
    iperf3          # měření propustnosti

    # Monitoring / utils
    lsof strace file tree pciutils
    openssl         # TLS nástroje

    # ODSTRANĚNO: smartmontools – pro fyzické disky, na VPS nedostupné
    # ODSTRANĚNO: lm_sensors   – teplotní čidla, na VPS nedostupná
    # ODSTRANĚNO: usbutils     – USB na VPS nedává smysl

    # Kontejnery
    incus

    # Certifikáty
    certbot
  ];
}