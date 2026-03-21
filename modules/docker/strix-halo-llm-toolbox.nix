{ config, pkgs, ... }:

{
  imports = [
    ../docker/docker.nix
  ];

  # Strix Halo Toolboxes - API-accessible containers for AMD Ryzen AI MAX+ (Strix Halo)
  virtualisation.oci-containers.containers.strix-halo-base = {
    image = "docker.io/kyuz0/amd-strix-halo-toolboxes:vulkan-radv";
    autoStart = false;
    devices = [ "/dev/dri" "/dev/kfd" ];
    # extraGroups = [ "video" "render" ];
    securityOpt = [ "seccomp=unconfined" ];
    volumes = [
      "/var/lib/containers/storage/strix-halo/base:/home/cmcraft"
    ];
  };

  virtualisation.oci-containers.containers.strix-halo-comfyui = {
    image = "docker.io/kyuz0/amd-strix-halo-comfyui:latest";
    autoStart = false;
    devices = [ "/dev/dri" "/dev/kfd" ];
    # extraGroups = [ "video" "render" ];
    securityOpt = [ "seccomp=unconfined" ];
    volumes = [
      "/var/lib/containers/storage/strix-halo/comfyui:/home/cmcraft"
    ];
    ports = [ "8080:8080" ];  # ComfyUI default port
  };

  virtualisation.oci-containers.containers.strix-halo-vllm = {
    image = "docker.io/kyuz0/vllm-therock-gfx1151:latest";
    autoStart = false;
    devices = [ "/dev/dri" "/dev/kfd" ];
    # extraGroups = [ "video" "render" ];
    securityOpt = [ "seccomp=unconfined" ];
    volumes = [
      "/var/lib/containers/storage/strix-halo/vllm:/home/cmcraft"
    ];
    ports = [ "8000:8000" ];  # vLLM default port
  };

  virtualisation.oci-containers.containers.strix-halo-finetuning = {
    image = "docker.io/kyuz0/amd-strix-halo-llm-finetuning:latest";
    autoStart = false;
    devices = [ "/dev/dri" "/dev/kfd" ];
    # extraGroups = [ "video" "render" ];
    securityOpt = [ "seccomp=unconfined" ];
    volumes = [
      "/var/lib/containers/storage/strix-halo/finetuning:/home/cmcraft"
    ];
    ports = [ "8888:8888" ];  # Jupyter Lab
  };
}