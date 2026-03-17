{ config, lib, pkgs, ... }:

{
  # --------------------------------------------------
  # Notebook power management
  # --------------------------------------------------

  # ❌ vypnout PPD (důležité)
  services.power-profiles-daemon.enable = false;

  # ✅ použít TLP
  services.tlp.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;

  # CPU chování
  powerManagement.cpuFreqGovernor = "powersave";

  services.tlp.settings = {
    CPU_MAX_PERF_ON_AC = 60;
    CPU_MAX_PERF_ON_BAT = 40;

    CPU_BOOST_ON_AC = 0;
    CPU_BOOST_ON_BAT = 0;
  };

  # --------------------------------------------------
  # Wi-Fi / Bluetooth power saving
  # --------------------------------------------------
  networking.networkmanager.wifi.powersave = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = lib.mkDefault false;
  };

  # --------------------------------------------------
  # Touchpad (libinput)
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
  # Suspend / resume
  # --------------------------------------------------
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
  };
}