{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    pavucontrol
    # pamixer
    nerd-fonts.symbols-only

    #hyprland stuff
    waypaper
    inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
    grim
    slurp
    wl-clip-persist

    # inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    webcord
    bitwarden-desktop
  ];
}