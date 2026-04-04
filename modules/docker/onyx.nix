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

    # Redis
    onyx-redis = {
      image = "redis:7-alpine";
      volumes = [ "/var/lib/containers/storage/onyx/redis:/data" ];
      extraOptions = [ "--network=onyx-net" ];
    };

    # Backend API Server
    onyx-api = {
      image = "onyxdotapp/onyx-backend:latest";
      dependsOn = [ "onyx-db" "onyx-vespa" "onyx-redis" ];
      autoStart = true;
      ports = [ "8080:8080" ];
      cmd = [ "/usr/bin/supervisord" "-c" "/etc/supervisor/conf.d/supervisord.conf" ];
      environmentFiles = [ config.sops.templates."postgres".path ];
      environment = {
        ONYX_ROLE = "api";
        REDIS_HOST = "onyx-redis";
        C_FORCE_ROOT = "true";
        DB_MIGRATION_REQUIRED = "true";
        VESPA_WAIT_TIMEOUT = "300";  
        TRANSFORMERS_CACHE = "/var/lib/onyx/model_cache";
      };
      volumes = [ "/var/lib/containers/storage/onyx/model_cache:/var/lib/onyx/model_cache" ];
      extraOptions = [ "--network=onyx-net" ];
    };

    # Frontend Web Server
    onyx-web = {
      image = "onyxdotapp/onyx-web-server:latest";
      autoStart = true;
      ports = [ "3000:3000" ];
      environment = { 
        ONYX_API_SERVER_URL = "http://192.168.1.214:8080";
        WEB_DOMAIN = "http://192.168.1.214:3000"; 
        INTERNAL_URL = "http://onyx-api:8080"; };
      dependsOn = [ "onyx-api" ];
      extraOptions = [ "--network=onyx-net" ];
    };
  };
}