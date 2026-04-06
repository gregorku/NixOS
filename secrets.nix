let
  serverVPStest = "age1ws5gtnuuamhksc8urq7rzekw3mrs968all0vkpvukc06dc4q7v0q7q58jr";
  ntbLenovo = "age1h85f8wc9sx5p5sep7h49qjgq3xvj9llwgz75fe0eep9ue6qt4f0s8djvs2";  # sem vlož výstup
in
{
  "serverVPStest/test-secret.age".publicKeys = [
    serverVPStest
    ntbLenovo
  ];

  # 🔐 SSH root key (jen server!)
  "VPSsecret/ssh-root.age".publicKeys = [
    serverVPStest
  ];


  ##################################################
  # 🔐 WIREGUARD (SERVER KEYS)
  ##################################################
  "VPSsecret/wireguard/wg1-private.age".publicKeys = [
  serverVPStest
  ];

  "VPSsecret/wireguard/wg2-private.age".publicKeys = [
  serverVPStest
  ];

  "VPSsecret/wireguard/wg3-private.age".publicKeys = [
  serverVPStest
  ];

  ##################################################
  # 🔐 WIREGUARD (SERVER KEYS)
  ##################################################
  "VPSsecret/wireguard/wg1_serverVPS-private.age".publicKeys = [
  serverVPStest
  ];

  "VPSsecret/wireguard/wg2_serverVPS-private.age".publicKeys = [
  serverVPStest
  ];

  "VPSsecret/wireguard/wg3_serverVPS-private.age".publicKeys = [
  serverVPStest
  ];

##################################################
# 🔐 WIREGUARD (mikrotik - doma)
##################################################
"VPSsecret/wireguard/wg1-mikrotik-doma-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg2-mikrotik-doma-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg3-mikrotik-doma-private.age".publicKeys = [ ntbLenovo ];

##################################################
# 🔐 WIREGUARD (mikrotik - prace)
##################################################
"VPSsecret/wireguard/wg1-mikrotik-prace-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg2-mikrotik-prace-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg3-mikrotik-prace-private.age".publicKeys = [ ntbLenovo ];

##################################################
# 🔐 WIREGUARD (mikrotik - jirkov)
##################################################
"VPSsecret/wireguard/wg1-mikrotik-jirkov-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg2-mikrotik-jirkov-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg3-mikrotik-jirkov-private.age".publicKeys = [ ntbLenovo ];

##################################################
# 🔐 WIREGUARD (mikrotik - udlice)
##################################################
"VPSsecret/wireguard/wg1-mikrotik-udlice-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg2-mikrotik-udlice-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg3-mikrotik-udlice-private.age".publicKeys = [ ntbLenovo ];

##################################################
# 🔐 WIREGUARD (mikrotik - klinovec)
##################################################
"VPSsecret/wireguard/wg1-mikrotik-klinovec-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg2-mikrotik-klinovec-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg3-mikrotik-klinovec-private.age".publicKeys = [ ntbLenovo ];

##################################################
# 🔐 WIREGUARD (mikrotik - bratrmach)
##################################################
"VPSsecret/wireguard/wg1-mikrotik-bratrmach-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg2-mikrotik-bratrmach-private.age".publicKeys = [ ntbLenovo ];
"VPSsecret/wireguard/wg3-mikrotik-bratrmach-private.age".publicKeys = [ ntbLenovo ];

##################################################
# 🔐 WIREGUARD (mikrotik - ntblenovo)
##################################################
"VPSsecret/wireguard/wg1-mikrotik-ntblenovo-private.age".publicKeys = [ ntbLenovo ];

##################################################
# 🔐 WIREGUARD (mikrotik - ntbpracovni)
##################################################
"VPSsecret/wireguard/wg1-mikrotik-ntbpracovni-private.age".publicKeys = [ ntbLenovo ];
}