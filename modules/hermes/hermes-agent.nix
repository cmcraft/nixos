# configuration.nix
{ config, ... }: 
let 
  stateDir = "/var/lib/hermes";
  workingDirectory = "${stateDir}/workspace";
in {
  services.hermes-agent = {
    enable = true;

    restart = "on-failure";
    restartSec = 5;

    stateDir = stateDir;
    workingDirectory = workingDirectory;
    environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
    extraDependencyGroups = [ "messaging" ];

    # base.nix
    settings = {
      model = {
        provider = "custom";
        base_url = "http://vivi.local:13305/v1";
        default = "Qwen3.6-35B-A3B-MTP-GGUF-Q8_0";
        context_length = "65536";
      };
      toolsets = [ "all" ];
      max_turns = 100;
      terminal = { backend = "local"; cwd = "."; timeout = 180; };
      compression = {
        enabled = true;
        threshold = 0.85;
        summary_model = "Qwen3.6-35B-A3B-MTP-GGUF-Q8_0";
      };
      # personality.nix
      display = { compact = false; personality = "kawaii"; };
      memory = { memory_enabled = true; user_profile_enabled = true; };
      agent = { max_turns = 60; verbose = false; };
    };

    documents = {
      # "USER.md" = ./documents/USER.md;
    };
  };

  serviceConfig = {
    # Set to at least 210s as recommended by the warning
    TimeoutStopSec = "210s"; 
  };
}