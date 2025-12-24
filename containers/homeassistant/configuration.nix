{
  default_config = {};

  homeassistant = {};

  http = {
    server_host = "0.0.0.0";
    server_port = 8123;
  };

  lovelace = {
    mode = "storage";
    resources = [];
  };

recorder = {
  db_url = "postgresql://homeassistant@postgres-ha/homeassistant";
  };

  zha = {
    usb_path = "/dev/zigbee";
  };

  automation = "!include_dir_merge_list automations";
  sensor = "!include_dir_merge_list sensors";
  template = "!include_dir_merge_list templates";
  script = "!include_dir_merge_list scripts";
}
