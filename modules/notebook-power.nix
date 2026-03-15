{ config, lib, pkgs, ... }:

{
  # --------------------------------------------------
  # Notebook power management
  # --------------------------------------------------
  services.power-profiles-daemon.enable = true;

  # Preferuj úspornější chování CPU
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

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
  # Suspend / resume (nové logind nastavení)
  # --------------------------------------------------
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
  };
}
