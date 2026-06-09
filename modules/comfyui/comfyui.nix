{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.comfyui-nix.nixosModules.default ];
  nixpkgs.overlays = [ inputs.comfyui-nix.overlays.default ];

  services.comfyui = {
    enable = true;
    gpuSupport = "rocm";

    # Force ComfyUI's python environment to pull the specific Strix Halo nightly binaries
    package = (inputs.comfyui-nix.packages.${pkgs.system}.comfyui-rocm.override (oldAttrs: {
      # Pin the package installer to grab torch/torchvision directly from AMD's nightly index
      pythonWithDeps = oldAttrs.pythonWithDeps.overrideAttrs (oldPython: {
        postBuild = ''
          ${oldPython.postBuild or ""}
          # Explicitly pull the optimized gfx1151 nightly build to prevent the segmentation fault
          $out/bin/pip install --force-reinstall --pre \
            --index-url https://rocm.nightlies.amd.com/v2/gfx1151/ \
            torch torchvision torchaudio
        '';
      });
    }));

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
