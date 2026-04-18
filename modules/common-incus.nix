{ config, pkgs, ... }:

{
  # Povolení samotné služby Incus
  virtualisation.incus = {
    enable = true;
    # Volitelně můžete povolit vestavěné uživatelské rozhraní (přístupné přes prohlížeč)
    ui.enable = true;
  };

  # Incus vyžaduje nftables pro správu sítě (místo starého iptables)
  networking.nftables.enable = true;

  # Nastavení firewallu - Incus si spravuje vlastní bridge (incusbr0), 
  # ale je dobré zajistit, aby NixOS neblokoval provoz mezi kontejnery.
  networking.firewall.trustedInterfaces = [ "incusbr0" ];

  # Důležité pro běh Dockeru uvnitř Incusu (nesting)
  # Toto nastavení zajistí, že bridge v kontejnerech nebudou filtrovány firewallem hostitele
  boot.kernel.sysctl."net.bridge.bridge-nf-call-iptables" = 0;
  boot.kernel.sysctl."net.bridge.bridge-nf-call-arptables" = 0;
  boot.kernel.sysctl."net.bridge.bridge-nf-call-ip6tables" = 0;

  # Přidání užitečných balíčků pro práci s kontejnery
  environment.systemPackages = with pkgs; [
    incus           # CLI klient
    virt-viewer     # Pro přístup ke grafické konzoli VM (pokud budete používat VM)
  ];

  # Poznámka: Nezapomeňte přidat svého uživatele do skupiny 'incus-admin' 
  # users.users.vás-uživatel.extraGroups = [ "incus-admin" ];
  # User access (no sudo needed)
  users.users.gregor.extraGroups = [
    "incus-admin"
  ];  
}