{ config, lib, pkgs, inputs, ... }:

{
  services.comfy-ui = {
    enable = true;
    gpuSupport = "rocm";
    enableManager = true;
    port = 8188;
    listenAddress = "0.0.0.0";  # Use "0.0.0.0" for network access
    dataDir = "/var/lib/comfy-ui";
    openFirewall = true;
    # environment = { };
  };

  users.users.comfy-ui = {
    isSystemUser = true;
    group = "comfy-ui";
    extraGroups = [ "render" ];
  };
  users.groups.comfyui = {};

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      { directory = "/var/lib/comfy-ui"; user = "comfy-ui"; group = "users"; mode = "u=rwx,g=rwx,o=rx"; }
    ];
  };
}
