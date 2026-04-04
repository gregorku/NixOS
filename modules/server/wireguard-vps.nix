wg1 = {
  ips = [ "10.100.100.1/24" ];
  listenPort = 51820;
  privateKeyFile = config.age.secrets.wg1_serverVPS-private.path;

  peers = [
    {
      # Mikrotik doma wg1
      publicKey = "hKQn0FYRlpAMedjbfyaQhKcitIiJ+I7wuaHiD1A8CVU=";
      allowedIPs = [ "10.100.100.100/32" ];
    }
  ];
};