{ config, pkgs, lib, ... }:
{
  services.haproxy = {
    enable = true;
    config = ''
      global
          log /dev/log local0
          log /dev/log local1 notice
          maxconn 10000
          user  haproxy
          group haproxy
          daemon
          ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets
          ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256

      defaults
          log     global
          mode    http
          option  httplog
          option  dontlognull
          option  forwardfor
          option  http-server-close
          timeout connect  5s
          timeout client  30s
          timeout server  30s
          retries 3

      #------------------------------------------------------------
      # Statistiky – přístupné na portu 8404 (jen z trusted IP)
      #------------------------------------------------------------
      listen stats
          bind *:8404
          stats enable
          stats uri /stats
          stats refresh 10s
          stats auth admin:ZMENTE_HESLO
          stats hide-version

      #------------------------------------------------------------
      # HTTP – přesměrování na HTTPS + ACME challenge
      #------------------------------------------------------------
      frontend http_in
          bind *:80
          mode http
          acl letsencrypt path_beg /.well-known/acme-challenge/
          use_backend letsencrypt_be if letsencrypt
          http-request redirect scheme https unless { ssl_fc }

      #------------------------------------------------------------
      # HTTPS – routing podle Host hlavičky
      #------------------------------------------------------------
      frontend https_in
          bind *:443 ssl crt /etc/haproxy/certs/
          mode http
          option httplog

          use_backend cockpit_be  if { hdr(host) -i cockpit.vasdomena.cz }
          use_backend app1_be     if { hdr(host) -i app1.vasdomena.cz }
          default_backend cockpit_be

      #------------------------------------------------------------
      # TCP pass-through (volitelné)
      #------------------------------------------------------------
      frontend tcp_8443
          bind *:8443
          mode tcp
          option tcplog
          default_backend cockpit_tcp_be

      #------------------------------------------------------------
      # Backendy
      #------------------------------------------------------------
      backend cockpit_be
          mode http
          option httpchk GET /
          server cockpit 127.0.0.1:9090 check ssl verify none

      backend cockpit_tcp_be
          mode tcp
          server cockpit 127.0.0.1:9090 check

      # Incus kontejner – příklad (upravte IP dle `incus list`)
      backend app1_be
          mode http
          option httpchk GET /health
          server app1 10.10.10.10:80 check inter 5s rise 2 fall 3

      # Let's Encrypt ACME
      backend letsencrypt_be
          mode http
          server certbot 127.0.0.1:8080
    '';
  };

  # Adresář pro SSL certifikáty
  systemd.tmpfiles.rules = [
    "d /etc/haproxy/certs 0750 haproxy haproxy -"
  ];

  # Certbot pro Let's Encrypt
  environment.systemPackages = with pkgs; [
    certbot
  ];
}