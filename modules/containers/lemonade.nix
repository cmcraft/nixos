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
      "HSA_OVERRIDE_GFX_VERSION" = "11.5.0";

      "LEMONADE_KV_CACHE_TYPE" = "q8_0";
      "LEMONADE_CTX_CACHE_SIZE" = "5";
      
      # --- MEMORY MANAGEMENT ---
      "LEMONADE_CTX_SIZE" = "98304"; 
      "LEMONADE_MAX_LOADED_MODELS" = "7"; 
      "LEMONADE_GLOBAL_TIMEOUT" = "0"; 
      "LEMONADE_MAX_VRAM_GB" = "124";
    };

    volumes = [
      "/var/lib/containers/storage/lemonade/models:/opt/lemonade/.cache/huggingface:z"
      "/var/lib/containers/storage/lemonade/lemonade-llama:/opt/lemonade/llama:z"
      "/var/lib/containers/storage/lemonade/config:/opt/lemonade/.cache/lemonade:z"
    ];

    extraOptions = [
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

  systemd.services.podman-lemonade = {
    serviceConfig = {
      ExecStartPre = [
        "+${pkgs.coreutils}/bin/mkdir -p /var/lib/containers/storage/lemonade/config"
        "+${pkgs.coreutils}/bin/rm -f /var/lib/containers/storage/lemonade/config/config.json"
        "+${pkgs.coreutils}/bin/cp -f ${config.sops.templates."lemonade-config".path} /var/lib/containers/storage/lemonade/config/config.json"
        "+${pkgs.coreutils}/bin/chown -R root:users /var/lib/containers/storage/lemonade"
        "+${pkgs.coreutils}/bin/chmod -R 0775 /var/lib/containers/storage/lemonade"
      ];
    };
  };

  sops.secrets = {
    "lemonade/api-key" = { };
    "lemonade/admin-api-key" = { };
  };

  sops.templates."lemonade-config".content = ''
    {
      "config_version": 1,
      "ctx_size": 98304,
      "disable_model_filtering": false,
      "enable_dgpu_gtt": false,
      "extra_models_dir": "",
      "flm": {
        "args": ""
      },
      "global_timeout": 300,
      "host": "0.0.0.0",
      "api_key": "${config.sops.placeholder."lemonade/api-key"}",
      "admin_api_key": "${config.sops.placeholder."lemonade/admin-api-key"}",
      "kokoro": {
        "cpu_bin": "builtin"
      },
      "llamacpp": {
        "args": "",
        "backend": "vulkan",
        "cpu_args": "",
        "cpu_bin": "builtin",
        "prefer_system": true,
        "rocm_args": "",
        "rocm_bin": "builtin",
        "vulkan_args": "",
        "vulkan_bin": "latest"
      },
      "log_level": "info",
      "max_loaded_models": 7,
      "models_dir": "auto",
      "no_broadcast": false,
      "no_fetch_executables": false,
      "offline": false,
      "port": 13305,
      "rocm_channel": "stable",
      "ryzenai": {
        "server_bin": "builtin"
      },
      "sdcpp": {
        "args": "",
        "backend": "auto",
        "cfg_scale": 7.0,
        "cpu_args": "",
        "cpu_bin": "builtin",
        "height": 512,
        "rocm_args": "",
        "rocm_bin": "builtin",
        "steps": 20,
        "vulkan_args": "",
        "vulkan_bin": "latest",
        "width": 512
      },
      "vllm": {
        "args": "",
        "backend": "auto"
      },
      "websocket_port": "auto",
      "whispercpp": {
        "args": "",
        "backend": "auto",
        "cpu_args": "",
        "cpu_bin": "builtin",
        "npu_args": "",
        "npu_bin": "builtin"
      }
    }
  '';
}