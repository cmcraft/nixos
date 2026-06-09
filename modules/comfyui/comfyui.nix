{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.comfyui-nix.nixosModules.default ];
  nixpkgs.overlays = [ inputs.comfyui-nix.overlays.default ];

  services.comfyui = {
    enable = true;
    gpuSupport = "rocm";
    enableManager = true;
    port = 8188;
    listenAddress = "0.0.0.0";  # Use "0.0.0.0" for network access
    dataDir = "/var/lib/comfyui";
    openFirewall = true;
    environment = {
      AMD_DEBUG = "no2d,nodisplay,nowb";
      HIP_LAUNCH_BLOCKING = "1";
      PYTORCH_CUDA_ALLOC_CONF = "backend:native";
      HSA_OVERRIDE_GFX_VERSION = "11.5.1";
     };
    extraArgs = [
    "--use-pytorch-cross-attention"
    "--highvram"
    "--disable-smart-memory"
    "--force-fp16"
  ];
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
