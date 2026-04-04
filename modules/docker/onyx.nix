{ config, pkgs, ... }: 
{
  # REMOVE the systemd.services.podman-onyx-pod block entirely.
  # We will use Podman's 'create if not exists' logic instead.

  virtualisation.oci-containers.containers = {
    "onyx-db" = {
      image = "postgres:15-alpine";
      # The '--pod' option will now point to a persistent pod name
      extraOptions = [ "--pod=new:onyx-pod" ]; 
      environmentFiles = [ config.sops.templates."postgres".path ];
      volumes = [ "/var/lib/containers/storage/onyx/db:/var/lib/postgresql/data:Z" ];
    };

    "onyx-index" = {
      image = "vespaengine/vespa:latest";
      extraOptions = [ "--pod=onyx-pod" ]; # Join the pod created by onyx-db
      volumes = [ "/var/lib/containers/storage/onyx/index:/opt/vespa/var:Z" ];
    };

    "onyx-background" = {
      image = "onyxdotapp/onyx-backend:latest";
      extraOptions = [ "--pod=onyx-pod" ];
      environment = {
        POSTGRES_HOST = "localhost";
        VESPA_HOST = "localhost";
        TASK_RS_WORKER = "true";
      };
    };

    "onyx-api" = {
      image = "onyxdotapp/onyx-backend:latest";
      # Expose ports here since we are doing this the Nix OCI way
      ports = [ "8080:8080" ];
      extraOptions = [ "--pod=onyx-pod" ];
      environment = {
        POSTGRES_HOST = "localhost";
        VESPA_HOST = "localhost";
        GEN_AI_MODEL_PROVIDER = "custom";
        GEN_AI_API_ENDPOINT = "http://192.168.1"; 
      };
      volumes = [ "/var/lib/containers/storage/onyx/config:/app/dynamic_config:Z" ];
    };

    "onyx-web" = {
      image = "onyxdotapp/onyx-web-server:latest";
      ports = [ "3000:3000" ];
      extraOptions = [ "--pod=onyx-pod" ];
      environment = {
        INTERNAL_URL = "http://localhost:8080";
        WEB_DOMAIN = "http://192.168.1.214:3000";
      };
    };
  };
}
