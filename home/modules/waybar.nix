{ config, lib, pkgs, ... }:
{
  programs.waybar.enable = true;
  programs.waybar.package = pkgs.waybar.overrideAttrs (oa: {
    mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
  });
  programs.waybar.settings = [
    {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ ];
        modules-center = [ ];
        modules-right = [ ];
        };
    }
];
}