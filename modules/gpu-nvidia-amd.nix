{ config, lib, pkgs, ... }:

{
  ##########################################################################
  # NVIDIA + AMD HYBRID GRAPHICS
  #
  # Notebook:
  #   AMD Ryzen 7 5800H
  #   NVIDIA RTX 3070 Laptop GPU
  #
  # Režim:
  #   AMD = integrovaná grafika / běžný provoz
  #   NVIDIA = PRIME Render Offload pro náročné aplikace a hry
  #
  # KDE Plasma / Wayland:
  #   modesetting.enable = true je důležité pro správnou funkci NVIDIA
  #   pod Waylandem.
  #
  # AKTUÁLNĚ ZAMČENO:
  #   NVIDIA 595.99.02
  #
  # Důvod:
  #   NVIDIA 595.71.05, kterou poskytoval aktuální nixpkgs jako
  #   nvidiaPackages.stable, není kompatibilní s Linuxem 7.2.x.
  #
  #   NVIDIA 595.99.02 tuto chybu opravuje a je potvrzena s Linuxem 7.2.x.
  ##########################################################################


  ##########################################################################
  # Grafický ovladač
  #
  # Používáme pouze NVIDIA ovladač.
  # AMDGPU je součástí kernelu a není nutné jej zde explicitně přidávat.
  ##########################################################################

  services.xserver.videoDrivers = [
    "nvidia"
  ];


  ##########################################################################
  # Základní grafická podpora
  #
  # hardware.graphics je současný název původního hardware.opengl.
  #
  # enable32Bit = true:
  #   důležité pro 32bitové aplikace, Steam, některé hry a starší
  #   grafické knihovny.
  ##########################################################################

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };


  ##########################################################################
  # NVIDIA
  ##########################################################################

  hardware.nvidia = {

    ########################################################################
    # Wayland / KDE Plasma
    #
    # Povinné pro správné DRM modesetting chování NVIDIA pod Waylandem.
    ########################################################################

    modesetting.enable = true;


    ########################################################################
    # Power Management
    #
    # enable = true:
    #   umožňuje NVIDIA správně přecházet mezi aktivním a úsporným stavem.
    #
    # finegrained = true:
    #   při běžné práci může být NVIDIA úplně vypnutá.
    #   Výpočetní/renderovací úlohy mohou GPU znovu aktivovat.
    #
    # Toto nastavení ponecháváme stejně jako v poslední funkční konfiguraci.
    ########################################################################

    powerManagement.enable = true;
    powerManagement.finegrained = true;


    ########################################################################
    # Proprietární NVIDIA kernel modul
    #
    # RTX 3070 podporuje open NVIDIA kernel modules, ale současná konfigurace
    # je ověřená s proprietární variantou.
    #
    # Proto záměrně NEPOUŽÍVÁME:
    #
    #   open = true;
    #
    ########################################################################

    open = false;


    ########################################################################
    # NVIDIA DRIVER - PEVNĚ ZAMČENO
    #
    # NIKDY zde nepoužíváme:
    #
    #   config.boot.kernelPackages.nvidiaPackages.stable
    #
    # protože aktuální nixpkgs poskytuje jako stable NVIDIA 595.71.05.
    #
    # 595.71.05:
    #   - funguje s Linuxem 7.1.x
    #   - NEfunguje správně s Linuxem 7.2.x
    #
    # 595.99.02:
    #   - opravená verze pro nové kernely
    #   - NVIDIA production branch
    #   - ověřeno na NixOS s Linuxem 7.2.x
    #
    # Proto driver explicitně připínáme na 595.99.02.
    ########################################################################

    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.99.02";

      # NVIDIA Linux x86_64 / AMD64
      sha256_64bit =
        "sha256-6HR3lYv3YwcFSTJL1a1slI66btIQ5EAFs+/4SUD24ew=";

      # NVIDIA Linux ARM64
      # Notebook je x86_64, ale hodnota je součástí definice driveru.
      sha256_aarch64 =
        "sha256-CCqHZTN2KNOZ4yZp2rDcuRJp9pHfRw47k4m4dWnS/2w=";

      # Open kernel module hash
      openSha256 =
        "sha256-T36x/jx8yQ8l3LFp1rZIrTfcSwbGy8YSAvXOUSptpb4=";

      # NVIDIA settings
      settingsSha256 =
        "sha256-GYCcnxfKPrTCrsmd25sMyzfC5cqJQJx0c31haooyTYM=";

      # NVIDIA persistence daemon
      persistencedSha256 =
        "sha256-VyKtF/HdHPQrHHK6opSO69M72LmnGZtauuchj9uuje8=";
    };


    ########################################################################
    # PRIME Render Offload
    #
    # Notebook používá:
    #
    #   AMD Radeon = integrovaná GPU
    #   NVIDIA RTX 3070 = výkonná GPU
    #
    # Běžná práce:
    #   AMD
    #
    # Hry / CUDA / náročná grafika:
    #   NVIDIA
    #
    # Spuštění programu přes NVIDIA:
    #
    #   nvidia-offload program
    #
    ########################################################################

    prime = {

      # PRIME Render Offload
      offload.enable = true;

      # Umožňuje používat příkaz:
      #
      #   nvidia-offload <program>
      #
      offload.enableOffloadCmd = true;


      ######################################################################
      # PCI Bus ID
      #
      # AMD:
      #   PCI:4:0:0
      #
      # NVIDIA:
      #   PCI:1:0:0
      #
      # Ověření:
      #
      #   lspci | grep -E "VGA|3D"
      #
      # Pokud se po změně hardwaru ID změní, je nutné upravit tato dvě
      # nastavení.
      ######################################################################

      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };


  ##########################################################################
  # Užitečné grafické nástroje
  ##########################################################################

  environment.systemPackages = with pkgs; [

    # Vulkan diagnostika
    #
    #   vulkaninfo
    #
    vulkan-tools


    # VA-API diagnostika
    #
    #   vainfo
    #
    libva-utils


    ########################################################################
    # NVIDIA PRIME OFFLOAD wrapper
    #
    # Použití:
    #
    #   nvidia-offload glxinfo
    #   nvidia-offload vkcube
    #   nvidia-offload steam
    #   nvidia-offload <hra>
    #
    # Kontrola NVIDIA rendereru:
    #
    #   nvidia-offload glxinfo | grep "OpenGL renderer"
    #
    ########################################################################

    (writeShellScriptBin "nvidia-offload" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only

      exec "$@"
    '')
  ];
}