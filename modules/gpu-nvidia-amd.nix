{ config, lib, pkgs, ... }:

{
  # Ovladače pro obě karty
  services.xserver.videoDrivers = [ "nvidia" ]; # "amdgpu" se u moderních verzí přidává automaticky k jádru

  hardware.graphics = { # Přejmenováno z hardware.opengl
    enable = true;
    enable32Bit = true; # Dříve driSupport32Bit
  };

  hardware.nvidia = {
    # Nutné pro Wayland a stabilitu Plasmy
    modesetting.enable = true;

    # Klíčové pro stabilitu po uspání notebooku
    powerManagement.enable = true;
    powerManagement.finegrained = true; # Vypne Nvidii úplně, když se nepoužívá

    # Proprietární ovladače jsou pro RTX 3070 stále jistota
    open = false;
    
    # Výběr nejnovějšího stabilního ovladače
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;

      # TATO ČÁST JE NUTNÁ:
      # U Ryzen 7 5800H jsou tato ID standardem (můžeš ověřit přes `lspci`)
      amdgpuBusId = "PCI:4:0:0"; 
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    libva-utils
    # Skript pro spouštění her na Nvidii: `nvidia-offload program`
    (writeShellScriptBin "nvidia-offload" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];
}
