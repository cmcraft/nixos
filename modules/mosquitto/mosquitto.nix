{config, ... }:
{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.cmcraft = {
          acl = [ "pattern readwrite #" ];
          hashedPassword = config.sops.secrets.cmcraft-password;
        };
      }
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1883 ];
  };
}