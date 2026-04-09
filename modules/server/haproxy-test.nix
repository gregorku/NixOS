{ config, pkgs, lib, ... }:

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
          mode    http
          option  httplog
          option  dontlognull
          option  forwardfor
          option  http-server-close
          timeout connect 5s
          timeout client  30s
          timeout server  30s

      # -------------------------
      # HTTP → HTTPS + ACME
      # -------------------------
      frontend http
          bind *:80
          mode http

          # Let's Encrypt challenge
          acl letsencrypt path_beg /.well-known/acme-challenge/
          use_backend letsencrypt if letsencrypt

          # redirect všeho ostatního
          http-request redirect scheme https code 301

      # -------------------------
      # HTTPS (hlavní vstup)
      # -------------------------
      frontend https
          bind *:443 ssl crt /etc/haproxy/certs/
          mode http
          option httplog

          # security headers
          http-response set-header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
          http-response set-header X-Frame-Options DENY
          http-response set-header X-Content-Type-Options nosniff

          # routing podle domén
          use_backend vaultwarden if { hdr(host) -i vault.serveftp.org }
          use_backend nextcloud   if { hdr(host) -i gregor.serveftp.org }
          use_backend zabbix      if { hdr(host) -i zabbix.serveftp.org }
          use_backend homeassistant if { hdr(host) -i homeassistant.serveftp.org }
          use_backend homeassistant_net if { hdr(host) -i homeassistant.serveftp.net }
          use_backend grafana     if { hdr(host) -i grafana.serveftp.org }

          default_backend nextcloud

      # -------------------------
      # Backendy
      # -------------------------

      backend vaultwarden
          option httpchk GET /
          server vaultwarden 200.1.1.200:80 check

      backend nextcloud
          option httpchk GET /status.php
          server nextcloud 120.100.100.12:22280 check

      backend zabbix
          option httpchk GET /
          server zabbix 200.1.1.200:80 check

      backend homeassistant
          server homeassistant 120.100.100.100:22080 check

      backend homeassistant_net
          server homeassistant_net 120.100.100.12:23080 check

      backend grafana
          server grafana 200.1.1.200:80 check

      # -------------------------
      # ACME backend
      # -------------------------
      backend letsencrypt
          server local 127.0.0.1:8080
    '';
  };

  # adresář pro certy
  systemd.tmpfiles.rules = [
    "d /etc/haproxy/certs 0750 haproxy haproxy -"
  ];

  # generování PEM pro HAProxy
  system.activationScripts.haproxy-certs = ''
    mkdir -p /etc/haproxy/certs
    for d in /var/lib/acme/*; do
      name=$(basename $d)
      cat $d/fullchain.pem $d/key.pem > /etc/haproxy/certs/$name.pem
    done
    chown -R haproxy:haproxy /etc/haproxy/certs
  '';
}