{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    pavucontrol
    # pamixer
    nerd-fonts.symbols-only
    ripgrep

    #hyprland stuff
    waypaper
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    grim
    slurp
    wl-clip-persist

    # inputs.zen-browser.packages.${pkgs.system}.default
    webcord
    bitwarden
  ];
}