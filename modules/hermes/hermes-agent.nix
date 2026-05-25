# configuration.nix
{ config, ... }: {
  services.hermes-agent = {
    enable = true;

    restart = "on-failure";
    restartSec = 5;

    environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;

    # base.nix
    settings = {
      model = {
        base_url = "http://127.0.0.1:13305/v1";
        default = "Qwen3.6-35B-A3B-MTP-GGUF-Q8_0";
      }
      toolsets = [ "all" ];
      max_turns = 100;
      terminal = { backend = "local"; cwd = "."; timeout = 180; };
      compression = {
        enabled = true;
        threshold = 0.85;
        summary_model = "Qwen3.6-35B-A3B-MTP-GGUF-Q8_0";
      };
    };

    # personality.nix
    settings = {
      display = { compact = false; personality = "kawaii"; };
      memory = { memory_enabled = true; user_profile_enabled = true; };
      agent = { max_turns = 60; verbose = false; };
    };

    documents = {
      # "USER.md" = ./documents/USER.md;
    };
  };
}