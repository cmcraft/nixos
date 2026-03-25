{ config, pkgs, ... }:

{
  imports = [
    ../docker/docker.nix
  ];

  # Strix Halo Toolboxes - API-accessible containers for AMD Ryzen AI MAX+ (Strix Halo)

  virtualisation.oci-containers.containers.strix-halo-comfyui = {
    image = "docker.io/kyuz0/amd-strix-halo-comfyui:latest";
    autoStart = true;
    devices = [ "/dev/dri" "/dev/kfd" ];
    extraOptions = [
      "--group-add=video"
      "--group-add=render"
      "--security-opt=seccomp=unconfined"
    ];
    volumes = [
      "/var/lib/containers/storage/strix-halo/comfyui:/home/cmcraft"
    ];
    ports = [ "8188:8188" ];  # ComfyUI default port
  };

  # Open-webui

  virtualisation.oci-containers.containers.open-webui = {
    image = "ghcr.io/open-webui/open-webui:main";
    autoStart = true;
    volumes = [
      "open-webui:/app/backend/data"
    ];
    ports = [ "3000:8080" ];  # ComfyUI default port
  };
}