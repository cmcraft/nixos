{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    inputs.swww.packages.${pkgs.system}.default
    waybar

    #hyprland stuff
    # hyprpaper # maybe this as opposed to swww
    hyprpicker
    hypridle
    hyprlock
    
    #gaming stuff
    steam
    steam-gamescope
    mangohud 
    protonup-qt 
    lutris 
    bottles 
    heroic
    #
  ];
}