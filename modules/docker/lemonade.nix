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
      "LEMONADE_LLAMACPP_BACKEND" = "rocm"; # Set to gpu for iGPU-only or hybrid
      "HSA_OVERRIDE_GFX_VERSION" = "11.5.1"; # Critical for 8060S compatibility
      "ROCR_VISIBLE_DEVICES" = "0";
      "HIP_VISIBLE_DEVICES" = "0";
      "FLASH_ATTENTION_TRITON_AMD_ENABLE" = "TRUE";
      "LEMONADE_CTX_SIZE=200000"
    };

    volumes = [
      "/var/lib/containers/storage/lemonade/models:/root/.cache/huggingface"
      "/var/lib/containers/containers/lemonade/lemonade-llama:/opt/lemonade/llama"
      "/var/lib/containers/storage/lemonade/config:/root/.cache/lemonade"
    ];

    # Grant hardware access for GPU/NPU acceleration
    extraOptions = [
    "--shm-size=32gb"                 # Essential for large models
  ];

  };
}