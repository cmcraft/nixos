{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
}