{ config, lib, pkgs, ... }:
{
  # --------------------------------------------------
  # Notebook power management
  # --------------------------------------------------
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = false;
  powerManagement.cpuFreqGovernor = "powersave";
  services.tlp.settings = {
    # CPU výkon (tiché chování)
    CPU_MAX_PERF_ON_AC = 60;
    CPU_MAX_PERF_ON_BAT = 40;
    CPU_BOOST_ON_AC = 0;
    CPU_BOOST_ON_BAT = 0;
    # USB power saving
    USB_AUTOSUSPEND = 1;
    # 👉 FIX pro tvoji USB myš (YICHIP 3151:3000)
    USB_DENYLIST = "3151:3000";
    # Lenovo platform profile (tichý režim)
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
  # --------------------------------------------------
  # Fix: USB myš (YICHIP 1-2.2) po probuzení ze spánku
  # --------------------------------------------------
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="3151", ATTR{idProduct}=="3000", \
      ATTR{power/autosuspend}="-1", ATTR{power/control}="on"
  '';

  systemd.services.usb-mouse-resume = {
    description = "Reset USB mouse (YICHIP 1-2.2) after suspend";
    after = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "usb-mouse-resume" ''
        sleep 1
        USB_PATH="1-2.2"
        echo "Resetting YICHIP mouse at $USB_PATH"
        echo "$USB_PATH" > /sys/bus/usb/drivers/usb/unbind
        sleep 0.5
        echo "$USB_PATH" > /sys/bus/usb/drivers/usb/bind
      '';
    };
  };
}