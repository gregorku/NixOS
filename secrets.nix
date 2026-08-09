let
  serverVPStest = "age1ws5gtnuuamhksc8urq7rzekw3mrs968all0vkpvukc06dc4q7v0q7q58jr";
  ntbLenovo = "age1pmlnsea6zm6c3gxa4uzvlzrslv7f5y0q858w3kkpudd0s88qvfeq9xuj0n";
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
  # 🔐 WIREGUARD (mikrotik - test)
  ##################################################
  "VPSsecret/wireguard/wg1-mikrotik-test-private.age".publicKeys = [ ntbLenovo ];
  "VPSsecret/wireguard/wg2-mikrotik-test-private.age".publicKeys = [ ntbLenovo ];
  "VPSsecret/wireguard/wg3-mikrotik-test-private.age".publicKeys = [ ntbLenovo ];

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
  # 🔐 WIREGUARD (Notebook - ntblenovo)
  ##################################################
  "VPSsecret/wireguard/wg1-ntblenovo-private.age".publicKeys = [ ntbLenovo ];

  ##################################################
  # 🔐 WIREGUARD (Notebook - ntbpracovni)
  ##################################################
  "VPSsecret/wireguard/wg1-ntbpracovni-private.age".publicKeys = [ ntbLenovo ];

  ##################################################
  # 🔐 WIREGUARD (Mobil - mujmobil)
  ##################################################
  "VPSsecret/wireguard/wg1-mujmobil-private.age".publicKeys = [ ntbLenovo ];

  ##################################################
  # 🔐 AI - OpenRouter (Aider)
  ##################################################
  "secrets/AI/openrouter-aider.age".publicKeys = [
    ntbLenovo
    #pracovniPc
    #serverVPStest
  ];
}
