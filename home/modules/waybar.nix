{ config, lib, pkgs, inputs, ... }:
{
  programs.waybar.enable = true;
  programs.waybar.settings.mainbar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ ];
        modules-center = [ ];
        modules-right = [ "clock" ];
        };
}