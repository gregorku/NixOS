{ config, pkgs, ... }:

{
  containers.test1 = {
    autoStart = true;
    privateNetwork = false;  # Použít bridge místo privátní sítě
    hostBridge = "br0";      # Použít váš bridge z bridge-network.nix

    config = { config, pkgs, ... }: {
      networking.hostName = "test1";
      networking.useDHCP = true;  # Kontejner dostane IP z DHCP přes bridge

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
