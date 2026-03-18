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
    # CPU výkon (tiché chování)
    CPU_MAX_PERF_ON_AC = 60;
    CPU_MAX_PERF_ON_BAT = 40;

    CPU_BOOST_ON_AC = 0;
    CPU_BOOST_ON_BAT = 0;

    # USB power saving (bez hacků)
    USB_AUTOSUSPEND = 1;

    # Lenovo platform profile (velmi důležité pro hluk)
    PLATFORM_PROFILE_ON_AC = "low-power";
    PLATFORM_PROFILE_ON_BAT = "low-power";

    # jemné doladění CPU idle
    SCHED_POWERSAVE_ON_AC = 1;
    SCHED_POWERSAVE_ON_BAT = 1;
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