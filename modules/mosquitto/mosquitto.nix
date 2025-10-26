{config, ... }:
{
  services.mosquitto = {
    enable = true;


    listeners = [
      #{
      #  users.cmcraft = {
      #    acl = [ "readwrite #" ];
      #    passwordFile = config.sops.secrets."mosquitto/password".path;
      #  };
      #}
      {
        acl = [ "readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;  
      }
    ];
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1883 ];
  };  
}