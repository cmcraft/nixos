{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  stylix.fonts.packages = [
    pkgs.nerd-fonts.symbols-only
  ];
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
}