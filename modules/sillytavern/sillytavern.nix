{ config, pkgs, ... }:

{
  services.sillytavern = {
    enable = true;
    port = 8045;
    listen = true;
    whitelist = false;
  };

  systemd.services.sillytavern = {
    serviceConfig = {
      # This reads the generated environment file at service startup
      EnvironmentFile = config.sops.templates."sillytavern-env".path;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8045 ];
  };  
}