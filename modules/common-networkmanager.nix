{ config, pkgs, lib, ... }:

{
  # ----------------------
  # NetworkManager
  # ----------------------
  networking.networkmanager.enable = true;
  networking.useNetworkd = false;

  # ----------------------
  # mDNS / Service discovery (Avahi)
  # ----------------------
  services.avahi = {
    enable = true;

    # umožní používat .local jména (nsswitch)
    nssmdns4 = true;

    # otevře firewall pro mDNS (UDP 5353)
    openFirewall = true;

    # 🔑 klíčové: přeposílání mDNS mezi sítěmi (WiFi ↔ Incus)
    reflector = true;

    # ❗ NEPOUŽÍVAT allowInterfaces:
    # způsobuje race condition při startu (WiFi ještě není ready)
    # → Avahi se pak hned ukončí
    #
    # allowInterfaces = [ "wlp4s0" "wlp2s0" "incusbr0" ];

    # ✔ bezpečné omezení (volitelné)
    # zakáže loopback, jinak nechá Avahi vybrat správná rozhraní
    denyInterfaces = [ "lo" ];
  };

  # ----------------------
  # Síťové nástroje a VPN
  # ----------------------
  environment.systemPackages = with pkgs; [
    networkmanager
    wireguard-tools
    psmisc

    # CLI nástroje (např. avahi-browse)
    avahi

    openconnect
    vpn-slice
  ];

  # ----------------------
  # Uživatel může spravovat síť
  # ----------------------
  users.users.gregor.extraGroups = [ "networkmanager" ];
}