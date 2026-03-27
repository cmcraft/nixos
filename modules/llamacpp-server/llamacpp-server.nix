{ inputs, pkgs, ... }: 
{
  systemd.services.llama-server = {
    description = "Llama.cpp HTTP Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # Adjust flags for your specific GPU and model path
      ExecStart = ''
        ${inputs.llamacpp-rocm.packages.${pkgs.stdenv.hostPlatform.system}.llamacpp-rocm}/bin/llama-server \
          --models-dir /var/lib/llama-cpp/models \
          --models-max 4 \
          --host 127.0.0.1 \
          --port 8080 \
      '';
      Restart = "always";
    };
  };
}