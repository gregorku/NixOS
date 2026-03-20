{ config, pkgs, lib, ... }:

{
  # ----------------------
  # NetworkManager
  # ----------------------
  networking.networkmanager.enable = true;

  # Nepoužívat systemd-networkd
  networking.useNetworkd = false;

  # ----------------------
  # mDNS / Service discovery (tiskárny, skenery, AirPrint)
  # ----------------------
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # ----------------------
  # Síťové nástroje a VPN
  # ----------------------
  environment.systemPackages = with pkgs; [
    networkmanager
    wireguard-tools
    avahi
    # Přidáno pro tvou pracovní VPN:
    openconnect
    vpn-slice
  ];

  # ----------------------
  # Zkratky pro terminál (Aliasy)
  # ----------------------
  programs.bash.shellAliases = {
    vpn-work = "sudo openconnect --user=kutik --authgroup=UADFD01-ST-2FA --servercert pin-sha256:Myb+eKrw7BcomYOUYcpUvpfhLaZ84nQDygatExjB44U= --mtu 1200 --script='vpn-slice --no-host-names --no-ns-hosts --nbns 10.0.0.0/8' u.ivpn.cz";
  };

  # ----------------------
  # Uživatel může spravovat síť
  # ----------------------
  users.users.gregor.extraGroups = [ "networkmanager" ];
}