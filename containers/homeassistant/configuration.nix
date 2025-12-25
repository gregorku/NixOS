{
  default_config = {};
  homeassistant = {};

  http = {
    server_host = "0.0.0.0";
    server_port = 8123;
    use_x_forwarded_for = true;
    trusted_proxies = [ "127.0.0.1" "::1" ];
  };

  recorder = {
    db_url = "postgresql://homeassistant@192.168.100.21/homeassistant";
  };

  zha = {
    usb_path = "/dev/zigbee";
  };

  automation = "!include_dir_merge_list automations";
  sensor = "!include_dir_merge_list sensors";
  template = "!include_dir_merge_list templates";
  script = "!include_dir_merge_list scripts";
}
