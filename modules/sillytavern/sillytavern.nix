{ config, pkgs, ... }:

{
  services.sillytavern = {
    enable = true;
    port = 8045;
    listenAddressIPv4 = "0.0.0.0";
    listen = true;
    whitelist = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8045 ];
  };  
}