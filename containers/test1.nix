{ config, pkgs, lib, ... }:

{
  containers.test1 = {
    autoStart = true;
    privateNetwork = false;  # Použít bridge místo privátní sítě
    hostBridge = "br0";      # Použít váš bridge z bridge-network.nix

    config = { config, pkgs, lib, ... }: {
      networking.hostName = "test1";

      # ŘEŠENÍ: Explicitné přepsání DHCP pomocí mkForce
      networking.useDHCP = lib.mkForce true;  # ← TOHLE JE KLÍČOVÉ

      # SSH pro přístup
      services.openssh.enable = true;
      services.openssh.settings.PasswordAuthentication = true;
      services.openssh.settings.PermitRootLogin = "yes";

      # Nastavit heslo pro root
      users.users.root.initialPassword = "test123";

      # Základní balíčky
      environment.systemPackages = with pkgs; [
        vim
        curl
        wget
        htop
        nano
        git
      ];

      # Firewall - povolit SSH
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 ];
    };
  };
}
