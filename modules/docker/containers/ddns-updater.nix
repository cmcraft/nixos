{ config, ... }:
{
  name = "ddns-updater";
  services.ddns-updater = {
    service = {
      container_name = "ddns-updater";
      environment = {
        BACKUP_PERIOD = "0";
        BACKUP_DIRECTORY = "/updater/data";
        CONFIG = ''
          {
            "settings": [
              {
                "provider": "cloudflare",
                "zone_identifier": "${config.sops.secrets.cloudflare-zone-identifier}",
                "domain": "knit-purl-binary.com",
                "ttl": 600,
                "ip_version": "ipv4",
                "token": "${config.sops.secrets.cloudflare-token}",
                "proxied": true
              }
            ]
          }
        '';
        LISTENING_ADDRESS = ":8500";
        LOG_CALLER = "hidden";
        LOG_LEVEL = "info";
        ROOT_URL = "/";
        PERIOD = "5m";
        UPDATE_COOLDOWN_PERIOD = "5m";
        PUBLICIP_FETCHERS = "all";
        PUBLICIP_HTTP_PROVIDERS = "all";
        PUBLICIPV4_HTTP_PROVIDERS = "all";
        PUBLICIPV6_HTTP_PROVIDERS = "all";
        PUBLICIP_DNS_PROVIDERS = "all";
        PUBLICIP_DNS_TIMEOUT = "3s";
        HTTP_TIMEOUT = "10s";
      };
      image = "qmcgaw/ddns-updater";
      ports = [
        "8500:8500/tcp" # host:container
      ];
      restart = "unless-stopped";
      volumes = [ "${toString ./.}/docker/ddns-updater/data:/updater/data" ];
    };
  };
}