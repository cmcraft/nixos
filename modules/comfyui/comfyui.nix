{ ... }:
{
  imports = [ comfyui-nix.nixosModules.default ];
  nixpkgs.overlays = [ comfyui-nix.overlays.default ];

  services.comfyui = {
    enable = true;
    gpuSupport = "rocm";  # Enable NVIDIA GPU acceleration (recommended for most users)
    # gpuSupport = "rocm";  # Enable AMD GPU acceleration
    # cudaCapabilities = [ "8.9" ];  # Optional: optimize system CUDA packages for RTX 40xx
    #   Note: Pre-built PyTorch wheels already support all GPU architectures
    enableManager = true;  # Enable the built-in ComfyUI Manager
    port = 8188;
    listenAddress = "0.0.0.0";  # Use "0.0.0.0" for network access
    dataDir = "/var/lib/comfyui";
    openFirewall = false;
    # extraArgs = [ "--lowvram" ];
    # environment = { };
  };
}