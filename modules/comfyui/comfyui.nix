{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.comfyui-nix.packages.${pkgs.stdenv.hostPlatform.system}.rocm ];

  services.comfyui = {
    enable = true;
    gpuSupport = "rocm";
    enableManager = true;
    port = 8188;
    listenAddress = "0.0.0.0";  # Use "0.0.0.0" for network access
    dataDir = "/var/lib/comfyui";
    openFirewall = true;
    # environment = { };
  };

  users.users.comfyui = {
    isSystemUser = true;
    group = "comfyui";
    extraGroups = [ "render" ];
  };
  users.groups.comfyui = {};

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      { directory = "/var/lib/comfyui"; user = "comfyui"; group = "users"; mode = "u=rwx,g=rwx,o=rx"; }
    ];
  };
}
