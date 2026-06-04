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

  sops.secrets = {
    "mosquitto/password" = {};
  };

  sops.templates."mosquitto.yaml" = {
    content = ''
      server: mqtt://localhost:1883
      user: cmcraft
      password: ${config.sops.placeholder."mosquitto/password"}
    '';
    path = "/var/lib/zigbee2mqtt/secrets.yaml";
    owner = "zigbee2mqtt";
  };
}