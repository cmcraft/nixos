{ config, pkgs, ... }: 
{
  imports = [
    ../docker/docker.nix
  ];
  virtualisation.oci-containers.containers = {
    
    # DB: Core Storage
    "onyx-db" = {
      image = "postgres:15-alpine";
      environmentFiles = [
        config.sops.templates."postgres".path
      ];
      volumes = [ "/var/lib/containers/storage/onyx/db:/var/lib/postgresql/data:Z" ];
    };

    # INDEX: The Vector Search Engine (Vespa)
    "onyx-index" = {
      image = "vespaengine/vespa:latest";
      volumes = [ "/var/lib/containers/storage/onyx/index:/opt/vespa/var:Z" ];
    };

    # BACKGROUND: Document Indexing & Web Scraping
    "onyx-background" = {
      image = "onyxdotapp/onyx-api-server:latest";
      cmd = [ "/app/scripts/run-background.sh" ];
      environment = {
        POSTGRES_HOST = "onyx-db";
        VESPA_HOST = "onyx-index";
      };
      dependsOn = [ "onyx-db" "onyx-index" ];
    };

    # API: Main Application Logic
    "onyx-api" = {
      image = "onyxdotapp/onyx-api-server:latest";
      ports = [ "8080:8080" ];
      extraOptions = [ "--add-host=host.containers.internal:host-gateway" ];
      environment = {
        POSTGRES_HOST = "onyx-db";
        VESPA_HOST = "onyx-index";
        # Podman-specific host resolution
        GEN_AI_MODEL_PROVIDER = "custom";
        GEN_AI_API_ENDPOINT = "http://containers.internal"; 
        WEB_DOMAIN = "http://192.168.1.214:3000";
      };
      volumes = [ "/var/lib/containers/storage/onyx/config:/app/dynamic_config:Z" ];
      dependsOn = [ "onyx-db" "onyx-index" ];
    };

    # WEB: The User Interface
    "onyx-web" = {
      image = "onyxdotapp/onyx-web-server:latest";
      ports = [ "3000:3000" ];
      environment = {
        INTERNAL_URL = "http://onyx-api:8080";
        WEB_DOMAIN = "http://192.168.1.214:3000";
      };
    };
  };
}
