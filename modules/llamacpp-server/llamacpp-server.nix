{ inputs, pkgs, ... }: 
{
  systemd.services.llama-server = {
    description = "Llama.cpp HTTP Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      WorkingDirectory= "/var/lib/llama-cpp";
      ExecStart = ''
        ${inputs.llamacpp-rocm.packages.${pkgs.stdenv.hostPlatform.system}.llamacpp-rocm}/bin/llama-server \
          --models-preset /var/lib/llama-cpp/models.ini \
          --sleep-idle-seconds 900 \
          --mmproj-auto \
          --models-max 4 \
          --host 127.0.0.1 \
          --port 8080 \
      '';
      Restart = "always";
    };
  };
}