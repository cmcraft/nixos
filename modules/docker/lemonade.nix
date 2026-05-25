{ config, pkgs, ... }:

{
  imports = [
    ../docker/docker.nix
  ];

  virtualisation.oci-containers.containers."lemonade" = {
    labels = {
        "io.containers.autoupdate" = "registry";
    };
    image = "ghcr.io/lemonade-sdk/lemonade-server:latest";
    autoStart = true;
    ports = [ "8000:8000" "9000:9000" "13305:13305" "13306:13306"];
    
    devices = [
      "/dev/dri"
      "/dev/kfd"
      "/dev/accel"
    ];

    environment = {
      "LEMONADE_LLAMACPP" = "rocm";
      "HSA_OVERRIDE_GFX_VERSION" = "11.5.1"; 
      "ROCR_VISIBLE_DEVICES" = "0";
      "HIP_VISIBLE_DEVICES" = "0";
      
      # --- SPEED BOOSTS ---
      "FLASH_ATTENTION_TRITON_AMD_ENABLE" = "TRUE";
      "GGML_HIP_ROCWMMA_FATTN" = "1"; # Force RDNA3 optimized attention
      "PYTORCH_TUNABLEOP_ENABLED" = "1";
      
      # KV Cache Quantization (Huge bandwidth savings)
      "LEMONADE_KV_CACHE_TYPE" = "q4_0"; # Reduces KV cache size/bandwidth by 4x
      
      # Speculative Decoding (The "Draft" model speedup)
      # Ensure this file exists in your models volume!
      # "LEMONADE_DRAFT_MODEL" = "/root/.cache/huggingface/hub/models--Qwen--Qwen2.5-1.5B-Instruct-GGUF/snapshots/91cad51170dc346986eccefdc2dd33a9da36ead9/qwen2.5-1.5b-instruct-q8_0.gguf";
      # "LEMONADE_SPECULATIVE_MODEL" = "/root/.cache/huggingface/hub/models--Qwen--Qwen2.5-1.5B-Instruct-GGUF/snapshots/91cad51170dc346986eccefdc2dd33a9da36ead9/qwen2.5-1.5b-instruct-q8_0.gguf";
      # "LEMONADE_DRAFT_NGL" = "-1"; # Offload draft to GPU
      
      # --- MEMORY MANAGEMENT ---
      "LEMONADE_CTX_SIZE" = "65536"; 
      "LEMONADE_MAX_LOADED_MODELS" = "2"; 
      "LEMONADE_GLOBAL_TIMEOUT" = "300"; 
      "LEMONADE_MAX_VRAM_GB" = "96";
    };

    volumes = [
      "/var/lib/containers/storage/lemonade/models:/root/.cache/huggingface"
      "/var/lib/containers/storage/lemonade/lemonade-llama:/opt/lemonade/llama"
      "/var/lib/containers/storage/lemonade/config:/root/.cache/lemonade"
    ];

    extraOptions = [
      # "--shm-size=96gb" 
      "--cap-add=SYS_PTRACE"
      "--security-opt=seccomp=unconfined"
      "--ipc=host" # Better memory throughput between host and container
    ];
  };
}