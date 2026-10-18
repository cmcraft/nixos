{ config, pkgs, ... }:
{
  services.gufo = {
    enable = true;
    host = "0.0.0.0";
    port = 8080;
    modelPath = "/persist/var/lib/gufo/models/gufo/Qwen3.8-Flash-Next-Uncensored-Gufo-Q4Mix.gguf";
    extraArgs = [
      "--mmproj" "/persist/var/lib/gufo/models/gufo/mmproj-BF16.gguf"
      "--served-model-name" "gufo" 
      "--context" "262144"
      "--speculative" "mtp"
      "--mtp-model" "/persist/var/lib/gufo/models/gufo-sidecar/mtp/Qwen3.8-Flash-CIRU-STRIX-Orca-MTP-Q8_0.gguf"
      "--draft-tokens" "6"
    ];
  };

  users.users.gufo = {
    isSystemUser = true;
    group = "gufo";
    extraGroups = [ "video" "render" ];
  };
  users.groups.gufo  = {};

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      { directory = "/var/lib/gufo/models"; user = "gufo"; group = "users"; mode = "u=rwx,g=rx,o=rx"; }
    ];
  };
}