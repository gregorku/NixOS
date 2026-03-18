{ config, lib, pkgs, ... }:

{
  # --------------------------------------------------
  # Notebook power management
  # --------------------------------------------------

  services.power-profiles-daemon.enable = lib.mkForce false;

  services.tlp.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;

  powerManagement.cpuFreqGovernor = "powersave";

  services.tlp.settings = {
    CPU_MAX_PERF_ON_AC = 60;
    CPU_MAX_PERF_ON_BAT = 40;

    CPU_BOOST_ON_AC = 0;
    CPU_BOOST_ON_BAT = 0;

    USB_AUTOSUSPEND = 1;

  };

  # --------------------------------------------------
  # Wi-Fi / Bluetooth
  # --------------------------------------------------
  networking.networkmanager.wifi.powersave = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = lib.mkDefault false;
  };

  # --------------------------------------------------
  # Touchpad
  # --------------------------------------------------
  services.libinput = {
    enable = true;

    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };

  # --------------------------------------------------
  # Suspend
  # --------------------------------------------------
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
  };
}