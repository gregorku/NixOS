let
  wifiIfaces =
    builtins.filter (iface: lib.hasPrefix "wlp" iface)
    (builtins.attrNames config.networking.interfaces);

  wifi =
    if wifiIfaces == []
    then [ "wlp2s0" "wlp4s0" ]  # fallback pro tvoje stroje
    else wifiIfaces;
in
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    reflector = true;
    allowInterfaces = wifi ++ [ "incusbr0" ];
  };
}