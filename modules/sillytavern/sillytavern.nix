{ config, pkgs, ... }:

{
  services.sillytavern = {
    enable = true;
    configFile = "${config.sops.templates."sillytavern-config".path}";
    user = "sillytavern";
    group = "sillytavern";

  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8045 ];
  };  
}