# common-print-Brother.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  printerName = "Brother_MFC_T920DW";
  printerIp = "192.168.100.201";
in {
  # ----------------------
  # Brother MFC-T920DW – tisk (IPP Everywhere, bez proprietárního ovladače)
  # ----------------------
  hardware.printers = {
    ensurePrinters = [
      {
        name = printerName;
        description = "Brother MFC-T920DW";
        location = "LAN";
        deviceUri = "ipp://${printerIp}/ipp/print";
        model = "everywhere";
        # ppdOptions = { PageSize = "A4"; };
      }
    ];
    # ensureDefaultPrinter = printerName;
  };

  # ----------------------
  # Skener – eSCL přes sane-airscan na pevné IP
  # (sane-airscan už máš v common-printing.nix; objevování přes mDNS
  #  funguje taky, tohle je jen jistota, když mDNS nepřejde)
  # ----------------------
  environment.etc."sane-config/airscan.conf".text = ''
    [devices]
    "Brother MFC-T920DW" = http://${printerIp}/eSCL, eSCL
  '';
}
