{ config, ...}:
{
  services.ddns-updater = {
    environment = {
      BACKUP_PERIOD = "0";
      BACKUP_DIRECTORY = "/updater/data";
      CONFIG = config.sops.templates."ddns-updater/config".path;
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
  }; 
}