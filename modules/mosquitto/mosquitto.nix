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
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1883 ];
  };  
}