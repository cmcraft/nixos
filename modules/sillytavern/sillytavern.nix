{ config, pkgs, ... }:

{
  services.sillytavern = {
    enable = true;
    port = 8045;
    listen = true;
    whitelist = false;
    serviceConfig = {
      EnvironmentFile = config.sops.templates."sillytavern-env".path;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8045 ];
  };  
}