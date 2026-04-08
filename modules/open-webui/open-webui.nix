{ ... }:
{
  services.open-webui = {
    enable = true;

    host = "0.0.0.0";
    openFirewall = true;
    port = 3000;
    stateDir = "/var/lib/open-webui";

    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      # OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
      # OLLAMA_BASE_URL = "http://127.0.0.1:11434";

      # # ComfyUI API settings
      # COMFYUI_API_BASE_URL = "http://127.0.0.1:8188";
      
      # # ROCm/GPU environment variables (matching comfyui.nix)
      # HSA_OVERRIDE_GFX_VERSION = "11.5.1";
      # HSA_ENABLE_SDMA = "0";
      # HSA_DISABLE_CACHE = "1";
      # PYTORCH_HIP_ALLOC_CONF = "garbage_collection_threshold:0.6,max_split_size_mb:512";
      # HIP_VISIBLE_DEVICES = "0";
      # ROC_ENABLE_PRE_ALLOCATION = "0";
      # PYTORCH_ROCM_ARCH = "gfx1151";
      # BNB_ROCM_ARCH = "gfx1151";
      # TORCH_SDP_KERNEL_OPTIONS = "flash,math,mem_efficient";
      # XFORMERS_FORCE_DISABLE_TRITON = "1";
    };
  };
}