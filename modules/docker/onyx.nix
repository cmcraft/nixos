{ config, pkgs, ... }: 
{
  imports = [
    ../docker/docker.nix
  ];
  virtualisation.oci-containers.containers = {
    
    # DB: Core Storage
    "onyx-db" = {
      image = "postgres:15-alpine";
      environment = { 
        POSTGRES_PASSWORD = "${config.sops.secrets."postgres/password".path}"; 
        POSTGRES_DB = "postgres";
      };
      volumes = [ "/var/lib/containers/storage/onyx/db:/var/lib/postgresql/data" ];
    };

    # INDEX: The Vector Search Engine (Vespa)
    "onyx-index" = {
      image = "vespaengine/vespa:latest";
      volumes = [ "/var/lib/containers/storage/onyx/index:/opt/vespa/var" ];
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
      environment = {
        POSTGRES_HOST = "onyx-db";
        VESPA_HOST = "onyx-index";
        # Connecting to Lemonade LLM on the Strix Halo host
        GEN_AI_MODEL_PROVIDER = "custom";
        GEN_AI_API_ENDPOINT = "http://127.0.0.1:8000/v1"; 
        WEB_DOMAIN = "http://192.168.1.214:3000";
      };
      volumes = [ "/var/lib/containers/storage/onyx/config:/app/dynamic_config" ];
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
