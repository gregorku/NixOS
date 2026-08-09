{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  ##################################################
  # SSH (default bezpečné)
  ##################################################
  services.openssh = {
    enable = lib.mkDefault true;

    settings = {
      PasswordAuthentication = lib.mkDefault true;

      KbdInteractiveAuthentication = lib.mkDefault true;

      PermitRootLogin = lib.mkDefault "no";
    };
  };

  ##################################################
  # System security služby
  ##################################################
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  security.rtkit.enable = true;
  security.protectKernelImage = true;

  ##################################################
  # 🔐 AGE / AGENIX
  ##################################################
  environment.systemPackages = [
    pkgs.age
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  age.identityPaths = lib.mkDefault [
    "/home/gregor/.application-data/agenix/keys.txt"
  ];
}
