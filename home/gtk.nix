{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];
}
