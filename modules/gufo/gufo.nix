{ config, pkgs, ... }:
{
  services.gufo = {
    enable = true;
    host = "0.0.0.0";
    port = 8080;
    modelPath = /var/lib/gufo/models/Qwen3.8-27B-UD-Q8_K_XL.gguf;
    extraArgs = [
      "--speculative" "dflash2"
      "--dflash-model" "/var/lib/gufo/models/Qwen3.8-27B-DFlash2-Q4_K_M.gguf"
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