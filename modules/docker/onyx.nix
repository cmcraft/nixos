{ config, pkgs, ... }: 
{
  # 1. Create the Pod with explicit dependency handling
  systemd.services.podman-onyx-pod = {
    path = [ pkgs.podman ];
    # Ensure this runs before the containers try to start
    before = [ "podman-onyx-db.service" "podman-onyx-index.service" "podman-onyx-api.service" "podman-onyx-web.service" "podman-onyx-background.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = "podman pod create --name onyx-pod -p 8080:8080 -p 3000:3000 --replace";
  };

  virtualisation.oci-containers.containers = {
    "onyx-db" = {
      image = "postgres:15-alpine";
      extraOptions = [ "--pod=onyx-pod" ];
      environmentFiles = [ config.sops.templates."postgres".path ];
      volumes = [ "/var/lib/containers/storage/onyx/db:/var/lib/postgresql/data:Z" ];
    };

    "onyx-index" = {
      image = "vespaengine/vespa:latest";
      extraOptions = [ "--pod=onyx-pod" ];
      volumes = [ "/var/lib/containers/storage/onyx/index:/opt/vespa/var:Z" ];
    };

    "onyx-background" = {
      image = "onyxdotapp/onyx-backend:latest";
      extraOptions = [ "--pod=onyx-pod" ];
      environment = {
        POSTGRES_HOST = "localhost";
        VESPA_HOST = "localhost";
        # CRITICAL: Tell the backend to act as a worker
        TASK_RS_WORKER = "true";
      };
    };

    "onyx-api" = {
      image = "onyxdotapp/onyx-backend:latest";
      extraOptions = [ "--pod=onyx-pod" ];
      environment = {
        POSTGRES_HOST = "localhost";
        VESPA_HOST = "localhost";
        GEN_AI_MODEL_PROVIDER = "custom";
        # FIXED: Added /v1 for Lemonade/OpenAI compatibility
        GEN_AI_API_ENDPOINT = "http://192.168.1"; 
      };
      volumes = [ "/var/lib/containers/storage/onyx/config:/app/dynamic_config:Z" ];
    };

    "onyx-web" = {
      image = "onyxdotapp/onyx-web-server:latest";
      extraOptions = [ "--pod=onyx-pod" ];
      environment = {
        # Inside the pod, the web server talks to the API on localhost
        INTERNAL_URL = "http://localhost:8080";
        WEB_DOMAIN = "http://192.168.1.214:3000";
      };
    };
  };
}
