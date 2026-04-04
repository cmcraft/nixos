{ config, pkgs, ... }: 
{
  imports = [
    ../docker/docker.nix
  ];

  virtualisation.oci-containers.containers = {
    # Relational Database
    onyx-db = {
      image = "postgres:15-alpine";
      autoStart = true;
      environmentFiles = [ config.sops.templates."postgres".path ];
      volumes = [ "/var/lib/containers/storage/onyx/postgres:/var/lib/postgresql/data" ];
      extraOptions = [ "--network=onyx-net" ];
    };

    # Vector Search Engine (Vespa)
    onyx-vespa = {
      image = "vespaengine/vespa:latest";
      autoStart = true;
      volumes = [ "/var/lib/containers/storage/onyx/vespa:/opt/vespa/var" ];
      extraOptions = [ "--network=onyx-net" ];
    };

    # Backend API Server
    onyx-api = {
      image = "onyx-dot-app/onyx-api-server:latest";
      dependsOn = [ "onyx-db" "onyx-vespa" ];
      autoStart = true;
      environmentFiles = [ config.sops.templates."postgres".path ];
      environment = {
        TRANSFORMERS_CACHE = "/var/lib/onyx/model_cache";
      };
      volumes = [ "/var/lib/containers/storage/onyx/model_cache:/var/lib/onyx/model_cache" ];
      extraOptions = [ "--network=onyx-net" ];
    };

    # Frontend Web Server
    onyx-web = {
      image = "onyx-dot-app/onyx-web-server:latest";
      autoStart = true;
      ports = [ "3000:3000" ];
      environment = { API_SERVER_HOST = "onyx-api"; };
      dependsOn = [ "onyx-api" ];
      extraOptions = [ "--network=onyx-net" ];
    };
  };
}