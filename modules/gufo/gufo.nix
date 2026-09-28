{ config, lib, pkgs, gufo, ... }:

with lib;

let
  cfg = config.services.gufo;
in {
  options.services.gufo = {
    enable = mkEnableOption "Gufo Strix Halo Inference Server";

    package = mkOption {
      type = types.package;
      default = gufo.packages.${pkgs.system}.default;
      description = "The Gufo derivation package to execute.";
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "IP address to bind the OpenAI-compatible server API to.";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Network port for the HTTP daemon.";
    };

    modelPath = mkOption {
      type = types.path;
      description = "Absolute local file path to the primary model GGUF file.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "--speculative" "dflash2" "--context" "4096" ];
      description = "Additional command line arguments passed cleanly to gufo serve llm.";
    };
  };

  config = mkIf cfg.enable {
    # 1. Open firewall port if host configuration permits public/external connections
    networking.firewall.allowedTCPPorts = mkIf (cfg.host != "127.0.0.1" && cfg.host != "localhost") [ cfg.port ];

    # 2. Systemd Service Deployment
    systemd.services.gufo = {
      description = "Gufo Local Inference Service Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/gufo serve \
            --host ${cfg.host} \
            --port ${toString cfg.port} \
            llm --model ${cfg.modelPath} \
            ${escapeShellArgs cfg.extraArgs}
        '';
        
        Restart = "always";
        RestartSec = "5s";

        # 3. Necessary security settings to interact with the ROCm layer
        DeviceAllow = [
          "/dev/kfd rw"
          "/dev/dri/renderD128 rw"
        ];
        
        # Gufo demands massive memory allocations for large context windows and unified memory architectures
        LimitMEMLOCK = "infinity"; 
        
        # Hardening security parameters
        DynamicUser = true;
        SupplementaryGroups = [ "video" "render" ]; # Automatically grants dynamic runtime user access to GPU nodes
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadOnlyPaths = [ cfg.modelPath ];
      };
    };
  };
}
  services.gufo = {
    enable = true;
    host = "127.0.0.1";
    port = 8080;
    modelPath = /var/lib/models/Qwen3.8-27B-UD-Q8_K_XL.gguf;
    extraArgs = [
      "--speculative" "dflash2"
      "--dflash-model" "/var/lib/models/Qwen3.8-27B-DFlash2-Q4_K_M.gguf"
    ];
  };