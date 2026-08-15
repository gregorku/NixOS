{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.haproxy = {
    enable = true;

    config = ''
      global
          log /dev/log local0
          log /dev/log local1 notice
          maxconn 10000
          daemon

      defaults
          log     global
          timeout connect 5s
          timeout client  50s
          timeout server  50s

      # -------------------------
      # HTTP (port 80)
      # -------------------------
      frontend http
          mode http
          bind *:80
          option httplog

          use_backend vaultwarden_http        if { hdr(host) -i vault.serveftp.org }
          use_backend nextcloud_http          if { hdr(host) -i gregor.serveftp.org }
          use_backend zabbix_http             if { hdr(host) -i zabbix.serveftp.org }
          use_backend homeassistant_http      if { hdr(host) -i homeassistant.serveftp.org }
          use_backend homeassistant_net_http  if { hdr(host) -i homeassistant.serveftp.net }
          use_backend grafana_http            if { hdr(host) -i grafana.serveftp.net }

          default_backend nextcloud_http

      # -------------------------
      # HTTP backends
      # -------------------------
      backend vaultwarden_http
          mode http
          option forwardfor
          server vaultwarden 10.10.10.10:80 send-proxy-v2

      backend nextcloud_http
          mode http
          option forwardfor
          server nextcloud 10.100.100.12:22280 send-proxy-v2

      backend zabbix_http
          mode http
          server zabbix 200.1.1.200:80

      backend homeassistant_http
          mode http
          server homeassistant 10.100.100.100:22080

      backend homeassistant_net_http
          mode http
          server homeassistant_net 10.100.100.12:23080

      backend grafana_http
          mode http
          option forwardfor
          server grafana 10.10.10.10:80 send-proxy-v2

      # -------------------------
      # HTTPS (TCP passthrough)
      # -------------------------
      frontend https
          mode tcp
          bind *:443

          tcp-request inspect-delay 5s
          tcp-request content accept if { req_ssl_hello_type 1 }

          use_backend vaultwarden_https        if { req_ssl_sni -i vault.serveftp.org }
          use_backend nextcloud_https          if { req_ssl_sni -i gregor.serveftp.org }
          use_backend zabbix_https             if { req_ssl_sni -i zabbix.serveftp.org }
          use_backend homeassistant_https      if { req_ssl_sni -i homeassistant.serveftp.org }
          use_backend homeassistant_net_https  if { req_ssl_sni -i homeassistant.serveftp.net }
          use_backend grafana_https            if { req_ssl_sni -i grafana.serveftp.net }

          default_backend nextcloud_https

      # -------------------------
      # HTTPS backends (různé porty!)
      # -------------------------
      backend vaultwarden_https
          mode tcp
          server vaultwarden 10.10.10.10:443 send-proxy-v2

      backend nextcloud_https
          mode tcp
          server nextcloud 10.100.100.12:22443 send-proxy-v2

      backend zabbix_https
          mode tcp
          server zabbix 200.1.1.200:443

      backend homeassistant_https
          mode tcp
          server homeassistant 10.100.100.100:22443

      backend homeassistant_net_https
          mode tcp
          server homeassistant_net 10.100.100.12:23443

      backend grafana_https
          mode tcp
          server grafana 10.10.10.10:443 send-proxy-v2

      # -------------------------
      # TCP služby (např. Zabbix agent)
      # -------------------------
      frontend tcp_zabbix
          mode tcp
          bind *:10051

          default_backend zabbix_tcp

      backend zabbix_tcp
          mode tcp
          server zabbix 200.1.1.111:10051
    '';
  };
}
