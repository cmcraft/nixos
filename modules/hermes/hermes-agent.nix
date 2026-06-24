# configuration.nix
{ config, lib, pkgs, ... }: 
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
    extraDependencyGroups = [ "matrix" "messaging" ];
    extraPackages = 
      [ 
        pkgs.pandoc 
        pkgs.imagemagick 
        pkgs.jq
        pkgs.python3
        pkgs.nodejs
        pkgs.wget 
      ]; 

    # base.nix
    settings = {
      model = {
        provider = "custom";
        base_url = "http://vivi.local:13305/v1";
        default = "Qwen3.6-35B-A3B-APEX-MTP-GGUF-I-Quality";
        context_length = "98304";
        llamacpp_args = "--flash-attn on --log-disable --mlock --mmap --reasoning off --spec-type draft-mtp --spec-draft-n-max 2";
      };
      toolsets = 
        [ 
          "kanban"
          "search"
          "terminal"
          "file"
          "browser"
          "vision"
          "skills"
          "tts"
          "todo"
          "memory"
          "session_search"
          "cronjob"
          "code_execution"
          "delegation"
          "clarify"
          "messaging"
          "debugging"
          "safe"
        ];
      max_turns = 100;
      terminal = { backend = "local"; cwd = "/var/lib/hermes/workspace"; timeout = 180; };
      compression = {
        enabled = true;
        abort_on_summary_failure = true;
        threshold = 0.35;
      };
      auxiliary = {
        compression = {
          model = "Qwen3.5-4B-MTP-GGUF";
        };
      };
      web = {
        search_backend = "searxing";
        backend = "searxing";
      };
      matrix = {
        require_mention = false;
        auto_thread = false;
        dm_auto_thread = false;
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

  users.users.hermes = {
    isSystemUser = true;
    extraGroups = [ "adm" "users"];
    group = lib.mkForce "users";
  };

  systemd.services.hermes-agent = {
    serviceConfig = {
      TimeoutStopSec = "210s";
    };
  };

  sops.secrets = {
    "hermes-env" = { format = "yaml"; };
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      { directory = "/var/lib/hermes"; user = "hermes"; group = "users"; mode = "u=rwx,g=rwx,o=rx"; }
    ];
  };
}