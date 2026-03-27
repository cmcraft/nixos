{ config, pkgs, ... }:
{
  services.comfyui = {
    enable = true;
    gpuSupport = "rocm";  # Enable AMD GPU acceleration
    enableManager = true;  # Enable the built-in ComfyUI Manager
    port = 8188;
    listenAddress = "0.0.0.0";  # Use "0.0.0.0" for network access
    dataDir = "/var/lib/comfyui";
    openFirewall = true;
    extraArgs = [ "--enable-dynamic-vram" ];
    environment = {
      HSA_OVERRIDE_GFX_VERSION = "11.5.0"; 
      HIP_VISIBLE_DEVICES = "0";
      # Point to the system-wide ROCm path
      ROCM_PATH = "/run/current-system/sw";
      ROC_ENABLE_PRE_ALLOCATION = "1";
      PYTORCH_ROCM_ARCH = "gfx1151"; 
      LD_LIBRARY_PATH = "${pkgs.rocmPackages.clr}/lib:${pkgs.libdrm}/lib"; 
    };
  };
}