{
  default_config = {};

  homeassistant = {
    external_url = "https://homeassistant.serveftp.org";
    internal_url = "http://192.168.100.230:8123";
  };

  http = {
    server_host = "0.0.0.0";
    server_port = 8123;

    use_x_forwarded_for = true;
    trusted_proxies = [
      "127.0.0.1"
      "::1"
      "192.168.100.232"   # Caddy kontejner
      "192.168.100.0/24"  # Lokální síť – přístup přímo bez proxy
    ];

    cors_allowed_origins = [
      "https://homeassistant.serveftp.org"
      "http://192.168.100.230:8123"
    ];
  };

  recorder = {
    db_url = "postgresql://homeassistant@192.168.100.231/homeassistant";
  };

  automation = "!include_dir_merge_list automations";
  sensor     = "!include_dir_merge_list sensors";
  template   = "!include_dir_merge_list templates";
  script     = "!include_dir_merge_list scripts";
}

