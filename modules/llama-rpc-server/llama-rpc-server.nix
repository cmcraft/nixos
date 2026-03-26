{ pkgs, ... }: 
{
  services.llamacpp-rpc-servers.main = {
    enable = true;
    package = pkgs.llamacpp-rocm;  # Choose your GPU target
    threads = 32;
    host = "127.0.0.1";  # Listen on all interfaces
    port = 50052;
    memory = 8192;  # 8GB backend memory
    device = "0";  # GPU device ID
    enableCache = true;
    openFirewall = true;
  };
}