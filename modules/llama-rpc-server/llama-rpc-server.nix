{ pkgs, ... }: 
{
  services.llamacpp-rpc-servers.main = {
    enable = true;
    package = pkgs.llamacpp-rocm;  # Choose your GPU target
  };
}