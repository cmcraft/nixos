{ config, pkgs, ... }: 
{
  # Create the Pod on boot
  systemd.services.podman-onyx-pod = {
    path = [ pkgs.podman ];
    serviceConfig.Type = "oneshot";
    script = "podman pod create --name onyx-pod -p 8080:8080 -p 3000:3000 --replace";
    wantedBy = [ "multi-user.target" ];
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
        POSTGRES_HOST = "localhost"; # Inside a pod, use localhost
        VESPA_HOST = "localhost";
      };
    };

    "onyx-api" = {
      image = "onyxdotapp/onyx-backend:latest";
      extraOptions = [ "--pod=onyx-pod" ];
      environment = {
        POSTGRES_HOST = "localhost";
        VESPA_HOST = "localhost";
        GEN_AI_MODEL_PROVIDER = "custom";
        # Use your LAN IP for Lemonade (Host)
        GEN_AI_API_ENDPOINT = "http://192.168.1"; 
      };
      volumes = [ "/var/lib/containers/storage/onyx/config:/app/dynamic_config:Z" ];
    };

    "onyx-web" = {
      image = "onyxdotapp/onyx-web-server:latest";
      extraOptions = [ "--pod=onyx-pod" ];
      environment = {
        INTERNAL_URL = "http://localhost:8080";
        WEB_DOMAIN = "http://192.168.1.214:3000";
      };
    };
  };
}
