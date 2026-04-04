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
  # 🔐 WIREGUARD (DOMA KEYS)
  ##################################################
  "VPSsecret/wireguard/wg1-doma-private.age".publicKeys = [
  ntbLenovo
  ];

  "VPSsecret/wireguard/wg2-doma-private.age".publicKeys = [
  ntbLenovo
  ];

  "VPSsecret/wireguard/wg3-doma-private.age".publicKeys = [
  ntbLenovo
  ];
}