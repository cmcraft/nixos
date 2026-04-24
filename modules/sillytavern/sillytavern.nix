{ config, pkgs, ... }:

{
  services.sillytavern = {
    enable = true;
    port = 8045;
    listen = true;
    whitelist = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8045 ];
  };  
}