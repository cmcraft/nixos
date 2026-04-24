{ config, pkgs, ... }:

{
  services.sillytavern = {
    enable = true;
    port = 8045;
    openFirewall = true;
  };
}