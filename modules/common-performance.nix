{ config, lib, pkgs, ... }:

{
  # --------------------------------------------------
  # Power management (moderní, bez konfliktů)
  # --------------------------------------------------
  services.power-profiles-daemon.enable = true;

  # --------------------------------------------------
  # CPU / scheduler optimalizace
  # --------------------------------------------------
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  # --------------------------------------------------
  # Filesystem / I/O drobnosti
  # --------------------------------------------------
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  # --------------------------------------------------
  # USB autosuspend (bezpečné)
  # --------------------------------------------------
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
  '';

  # --------------------------------------------------
  # KDE / desktop optimalizace
  # --------------------------------------------------
  environment.sessionVariables = {
    # lepší chování Qt/Wayland
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # menší wakeups u Qt aplikací
    QT_QPA_PLATFORMTHEME = "kde";
  };

  # --------------------------------------------------
  # Omez Baloo (indexace) – bezpečné defaulty
  # --------------------------------------------------
  services.baloo.enable = true;
  services.baloo.exclude = [
    "/nix/store"
    "/var/tmp"
    "/tmp"
  ];
}
