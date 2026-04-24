{ config, pkgs, ... }:

{
  services.sillytavern = {
    enable = true;
    configFile = "${config.sops.templates."sillytavern-config".path}"

  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8045 ];
  };  
}