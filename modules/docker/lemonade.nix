{ config, pkgs, ... }:

{
  imports = [
    ../docker/docker.nix
  ];

  virtualisation.oci-containers.containers."lemonade" = {
    image = "ghcr.io/lemonade-sdk/lemonade-server:latest";
    autoStart = true;
    ports = [ "8000:8000" ];
    
    devices = [
      "/dev/dri"
      "/dev/kfd"
      "/dev/accel"
    ];
    # Environment variables for hardware and server config
    environment = {
      "LEMONADE_LLAMACPP" = "rocm"; # LlamaCpp backend: vulkan, rocm, or cpu
      "HSA_OVERRIDE_GFX_VERSION" = "11.5.1"; # Critical for 8060S compatibility
      "ROCR_VISIBLE_DEVICES" = "0";
      "HIP_VISIBLE_DEVICES" = "0";
      "FLASH_ATTENTION_TRITON_AMD_ENABLE" = "TRUE";
      "PYTORCH_TUNABLEOP_ENABLED" = "1"; # Vital for 40-CU throughput
      "LEMONADE_CTX_SIZE" = "32768"; # Default context size for models
      "LEMONADE_MAX_LOADED_MODELS" = "2"; # Maximum models to keep loaded per type
      "LEMONADE_GLOBAL_TIMEOUT" = "900"; # 15 minutes in seconds for auto-unload
    };

    volumes = [
      "/var/lib/containers/storage/lemonade/models:/root/.cache/huggingface"
      "/var/lib/containers/storage/lemonade/lemonade-llama:/opt/lemonade/llama"
      "/var/lib/containers/storage/lemonade/config:/root/.cache/lemonade"
    ];

    # Grant hardware access for GPU/NPU acceleration
    extraOptions = [
      "--shm-size=64gb" # Essential for large models
    ];

  };
}