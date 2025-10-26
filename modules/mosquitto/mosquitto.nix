{config, ... }:
{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.cmcraft = {
          acl = [ "readwrite #" ];
          passwordFile = config.sops.secrets."mosquitto/password".path;
        };
      }
    ];
  };
}