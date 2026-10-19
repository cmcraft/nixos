{ config, pkgs, ... }:
{
  services.gufo = {
    enable = true;
    host = "0.0.0.0";
    port = 8080;
    modelPath = "/var/lib/gufo/models/Qwen3.8-flash-next/UD-Q4_K_XL/Qwen3.8-Flash-Next-UD-Q4_K_XL-00001-of-00004.gguf";
    extraArgs = [
      "--mmproj" "/var/lib/gufo/models/gufo/mmproj-BF16.gguf"
      "--served-model-name" "gufo" 
      "--context" "262144"
      "--sessions" "2"
      "--speculative" "mtp"
      "--mtp-model" "/var/lib/gufo/models/Qwen3.8-flash-next/MTP/mtp-Qwen3.8-Flash-Next-shared-Q8_0.gguf"
      "--draft-tokens" "6"    ];
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
      { directory = "/var/lib/gufo"; user = "gufo"; group = "users"; mode = "u=rwx,g=rx,o=rx"; }
    ];
  };
}