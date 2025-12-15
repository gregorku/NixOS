{ config, lib, pkgs, ... }:

{
  # --------------------------------------------------
  # Notebook power management
  # --------------------------------------------------
  services.power-profiles-daemon.enable = true;

  # Preferuj úspornější chování na baterii
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  # --------------------------------------------------
  # Wi-Fi / Bluetooth power saving
  # --------------------------------------------------
  networking.networkmanager.wifi.powersave = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # --------------------------------------------------
  # Touchpad (libinput)
  # --------------------------------------------------
  services.xserver.libinput = {
    enable = true;

    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };

  # --------------------------------------------------
  # Suspend / resume
  # --------------------------------------------------
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "ignore";
  };

  # --------------------------------------------------
  # Kernel / VM drobnosti
  # --------------------------------------------------
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };
}
