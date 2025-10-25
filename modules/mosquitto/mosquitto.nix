{config, ... }:
{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.cmcraft = {
          acl = [ "pattern readwrite #" ];
          password_file = config.sops.templates."mosquitto".path;
        };
      }
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1883 ];
  };
}