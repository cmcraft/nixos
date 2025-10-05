{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    pavucontrol
    pamixer

    #hyprland stuff
    # hyprpaper # maybe this as opposed to swww
    waypaper
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    grim
    slurp
    wl-clip-persist

    inputs.zen-browser.packages.${pkgs.system}.default
    webcord
    bitwarden
  ];
}