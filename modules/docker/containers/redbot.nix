{ config, ... }:
{
  name = "redbot";
  services.redbot = {
    service = {
      environment = {
        PREFIX = "!";
        PUID = "1000";
        TOKEN = config.sops.secrets.redbot-token;
        TZ = "America/Chicago";
      };
      image = "phasecorex/red-discordbot:full";
      restart = "unless-stopped";
      volumes = [ "${toString ./.}/docker/redbot:/data" ];
    };
  };
}