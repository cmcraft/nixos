{ config, pkgs, ... }:

{
  imports = [
    ../containers/containers.nix
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
      "LEMONADE_LLAMACPP" = "vulkan";
      "GGML_VULKAN_DEVICE" = "0";
      "GGML_VK_PREFER_HOST_MEMORY" = "1";
      "RADV_PERFTEST" = "nogttspill";
      
      # KV Cache Quantization (Huge bandwidth savings)
      "LEMONADE_KV_CACHE_TYPE" = "q4_0"; # Reduces KV cache size/bandwidth by 4x
      "LEMONADE_CTX_CACHE_SIZE" = "5";
      
      # Speculative Decoding (The "Draft" model speedup)
      # Ensure this file exists in your models volume!
      # "LEMONADE_SPECULATIVE_MODEL" = "/root/.cache/huggingface/hub/models--Qwen--Qwen2.5-1.5B-Instruct-GGUF/snapshots/91cad51170dc346986eccefdc2dd33a9da36ead9/qwen2.5-1.5b-instruct-q8_0.gguf";
      "LEMONADE_DRAFT_MODEL" = "/root/.cache/huggingface/hub/models--unsloth--Qwen3.5-4B-MTP-GGUF/snapshots/86835bf9949e4d14d6860f7910b1340ad4f271a9/Qwen3.5-4B-UD-Q4_K_XL.gguf";
      "LEMONADE_DRAFT_NGL" = "-1";  # offload to GPU

      # --- MEMORY MANAGEMENT ---
      "LEMONADE_CTX_SIZE" = "98304"; 
      "LEMONADE_MAX_LOADED_MODELS" = "7"; 
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

  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = [ 8000 ];
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/containers/storage/lemonade/config"
      "/var/lib/containers/storage/lemonade/lemonade-llama"
      "/var/lib/containers/storage/lemonade/models"
    ];
  };
}